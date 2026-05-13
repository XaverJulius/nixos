#!/usr/bin/env bash
set -e

nix_string() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  printf '"%s"' "$value"
}

write_user_config() {
  local target="$1"

  cat > "$target" <<EOF
{
  username = $(nix_string "$USERNAME");
  name = $(nix_string "$USER_NAME");
  email = $(nix_string "$USER_EMAIL");
}
EOF
}

shell_quote() {
  local value="$1"
  value="${value//\'/\'\\\'\'}"
  printf "'%s'" "$value"
}

set_user_password() {
  local passwd_path="/nix/var/nix/profiles/system/sw/bin/passwd"

  if [[ -x "/mnt$passwd_path" ]]; then
    chroot /mnt "$passwd_path" "$USERNAME"
    return
  fi

  if command -v nixos-enter >/dev/null 2>&1; then
    nixos-enter --root /mnt -c "passwd $(shell_quote "$USERNAME")"
    return
  fi

  echo "Could not find passwd in the installed system."
  echo "Boot the system and log in with the initial password 'changeme', then run: passwd"
  exit 1
}

echo "User settings:"
read -e -p "Username: " USERNAME
read -e -p "Full name: " USER_NAME
read -e -p "Email: " USER_EMAIL

if [[ -z "$USERNAME" || -z "$USER_NAME" || -z "$USER_EMAIL" ]]; then
  echo "Username, full name, and email are required."
  exit 1
fi

if [[ ! "$USERNAME" =~ ^[a-z_][a-z0-9_-]*[$]?$ ]]; then
  echo "Username '$USERNAME' is not a valid Linux username."
  exit 1
fi

echo

echo "Available disks:"
lsblk -d -o NAME,SIZE,MODEL

echo
read -e -p "Disk: " DISK

if [[ "$DISK" != /dev/* ]]; then
  DISK="/dev/$DISK"
fi

if [[ ! -b "$DISK" ]]; then
  echo "Disk '$DISK' not found."
  exit 1
fi

echo
read -p "This will ERASE $DISK. Type 'yes' to continue: " confirm
[ "$confirm" = "yes" ] || exit 1

echo "Partitioning disk..."

parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MiB 512MiB
parted $DISK -- set 1 esp on
parted $DISK -- mkpart primary ext4 512MiB 100%

# Handle devices whose partition names include 'p'
BOOT_PART="${DISK}1"
ROOT_PART="${DISK}2"

if [[ "$DISK" == *"nvme"* || "$DISK" == *"mmcblk"* ]]; then
  BOOT_PART="${DISK}p1"
  ROOT_PART="${DISK}p2"
fi

echo "Formatting..."

mkfs.fat -F32 $BOOT_PART
mkfs.ext4 $ROOT_PART

echo "Mounting..."

mount $ROOT_PART /mnt
mkdir -p /mnt/boot
mount $BOOT_PART /mnt/boot

echo "Generating hardware config..."

nixos-generate-config --root /mnt

echo "Creating temporary swapfile for install..."

if command -v fallocate >/dev/null 2>&1; then
  fallocate -l 8G /mnt/swapfile
else
  dd if=/dev/zero of=/mnt/swapfile bs=1M count=8192 status=progress
fi

chmod 600 /mnt/swapfile
mkswap /mnt/swapfile
swapon /mnt/swapfile

echo "Copying config..."

install -Dm644 flake.nix /mnt/etc/nixos/flake.nix
write_user_config /mnt/etc/nixos/user.nix
install -Dm644 configuration.nix /mnt/etc/nixos/configuration.nix
install -Dm755 install.sh /mnt/etc/nixos/install.sh
install -Dm644 README.md /mnt/etc/nixos/README.md
if [[ -f flake.lock ]]; then
  install -Dm644 flake.lock /mnt/etc/nixos/flake.lock
fi
cp -rT modules /mnt/etc/nixos/modules
cp -rT home /mnt/etc/nixos/home

if [[ ! -f /mnt/etc/nixos/flake.lock ]]; then
  echo "Generating flake.lock..."
  nix --extra-experimental-features "nix-command flakes" flake lock /mnt/etc/nixos
fi

echo "Installing system..."

nixos-install --max-jobs 2 --cores 2 --flake /mnt/etc/nixos#nixos

echo
echo "Setting password for user $USERNAME..."
set_user_password

echo "Done! Rebooting..."

reboot
