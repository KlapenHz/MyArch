#!/usr/bin/bash

echo "1. Update the system clock"
timedatectl set-ntp true
sleep 3s

echo -e "\n------------------------------------------------"
echo "Ensure the system clock is accurate"
timedatectl

echo -e "\n------------------------------------------------"
echo "2. Partitioning the disks..."
lsblk

echo -e "\n------------------------------------------------"
read -p "Enter the partition to install: " install_partition
install_partition=/dev/${install_partition}

read -p "Enter the boot partition: " boot_partition
boot_partition=/dev/${boot_partition}
export boot_partition

while true; do
    read -p "Do you wish to format the partition [y/n]? " yn
    case $yn in
        [Yy]* ) echo "Formating..."; mkfs.ext4 $install_partition; break;;
        [Nn]* ) echo "Skipping..."; break;;
        * ) echo "Please answer yes [y] or no [n].";;
    esac
done

echo -e "\n------------------------------------------------"
echo "Mounting..."
mount $install_partition /mnt

echo -e "\n------------------------------------------------"
echo "Installing esential packages"

while true; do
    read -p "Do you want to install additional packages like lvm2 and ntfs-3g [y/n]? " yn
    case $yn in
        [Yy]* ) pacstrap /mnt base linux linux-firmware grub efibootmgr vim networkmanager lvm2 ntfs-3g os-prober man sudo; break;;
        [Nn]* ) pacstrap /mnt base linux linux-firmware grub efibootmgr vim networkmanager os-prober man sudo; break;;
        * ) echo "Please answer yes [y] or no [n].";;
    esac
done

echo -e "\n------------------------------------------------"
echo "Generating the fstab file..."
genfstab -U /mnt >> /mnt/etc/fstab
echo -e "\n------------------------------------------------"
echo "Copying post instalation file into system..."
cp ek-arch-post-install.sh /mnt/
chmod +x /mnt/ek-arch-post-install.sh
echo -e "\n------------------------------------------------"
echo "Starting second part..."
arch-chroot /mnt ./ek-arch-post-install.sh

