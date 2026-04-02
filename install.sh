#!/usr/bin/env bash
set -e

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

echo "Copying config..."

install -Dm644 flake.nix /mnt/etc/nixos/flake.nix
install -Dm644 configuration.nix /mnt/etc/nixos/configuration.nix
install -Dm755 install.sh /mnt/etc/nixos/install.sh
install -Dm644 README.md /mnt/etc/nixos/README.md
cp -rT modules /mnt/etc/nixos/modules
cp -rT home /mnt/etc/nixos/home

echo "Installing system..."

nixos-install --flake /mnt/etc/nixos#nixos

echo
echo "Setting password for user xaver..."
chroot /mnt /run/current-system/sw/bin/passwd xaver

echo "Done! Rebooting..."

reboot
