#!/usr/bin/env bash
set -e

echo "Available disks:"
lsblk -d -o NAME,SIZE,MODEL

echo
read -e -p "Disk: " DISK

echo
read -p "This will ERASE $DISK. Type 'yes' to continue: " confirm
[ "$confirm" = "yes" ] || exit 1

echo "Partitioning disk..."

parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MiB 512MiB
parted $DISK -- set 1 esp on
parted $DISK -- mkpart primary ext4 512MiB 100%

# Handle nvme naming (adds 'p')
BOOT_PART="${DISK}1"
ROOT_PART="${DISK}2"

if [[ "$DISK" == *"nvme"* ]]; then
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

cp -r . /mnt/etc/nixos
cd /mnt/etc/nixos

echo "Installing system..."

nixos-install --flake .#nixos

echo "Done! Rebooting..."

reboot