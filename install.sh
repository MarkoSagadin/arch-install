#! /bin/bash

# This a Arch Linux Installation Script.

echo "Arch Installer"

BOOT_PARTITION="/dev/nvme0n1p1"
SWAP_PARTITION="/dev/nvme0n1p5"
ROOT_PARTITION="/dev/nvme0n1p6"

# Set up network connection
read -p 'Did you read this script and set root, boot and swap partitions? [y/N]: ' neton
if ! [ $neton = 'y' ] && ! [ $neton = 'Y' ]
then 
    echo "Make changes and run this again..."
    exit
fi
# Set up network connection
read -p 'Are you connected to internet? [y/N]: ' neton
if ! [ $neton = 'y' ] && ! [ $neton = 'Y' ]
then 
    echo "Connect to internet with iwctl to continue..."
    exit
fi

## Format the partitions
mkfs.ext4   $ROOT_PARTITION
mkswap      $SWAP_PARTITION
swapon      $SWAP_PARTITION

# Mount the partitions
mount $ROOT_PARTITION /mnt
mkdir -pv /mnt/boot
mount $BOOT_PARTITION /mnt/boot

# Set up time
timedatectl set-ntp true

# Install Arch Linux
echo "Starting install.."
echo "Installing Arch Linux"
pacstrap /mnt \
        base \
        base-devel \
        linux \
        linux-firmware \
        sudo \
        gvim \
        dhcpcd

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Copy post-install system configuration script to new /root
cp -rfv post-install.sh /mnt
chmod a+x /mnt/post-install.sh

# Copy refind conf file to new boot
cp -rfv refind_linux.conf /mnt

# Chroot into new system
echo "After chrooting into newly installed OS, please run the post-install.sh by executing ./post-install.sh"
echo "Press any key to chroot..."
read tmpvar
arch-chroot /mnt

# Finish
echo "If post-install.sh was run succesfully, you will now have a fully working bootable Arch Linux system installed."
echo "The only thing left is to reboot into the new system."
echo "Remove installation medium."
echo "Press any key to reboot or Ctrl+C to cancel..."
read tmpvar
umount -R /mnt
reboot
