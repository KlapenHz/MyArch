#!/usr/bin/bash

echo -e "\n------------------------------------------------"
echo "Setting timezone..."
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

echo -e "\n------------------------------------------------"
echo "Generating locales..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "pl_PL.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo -e "\n------------------------------------------------"
echo "Setting LANG variable"
echo "LANG=pl_PL.UTF-8" > /etc/locale.conf

echo -e "\n------------------------------------------------"
echo "Setting vconsole keyboard layout"
echo "KEYMAP=pl" > /etc/vconsole.conf
echo "FONT=Lat2-Terminus16" >> /etc/vconsole.conf
echo "FONT_MAP=8859-2" >> /etc/vconsole.conf

echo -e "\n------------------------------------------------"
echo "Network configuration"
read -p "Enter your computer name: " hostname
echo "Saving to /etc/hostname..."
echo $hostname > /etc/hostname
echo "Setting up /etc/hosts file"
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname" >> /etc/hosts
echo "Checking hostname..."
cat /etc/hostname
echo "Checking hosts file..."
cat /etc/hosts

echo -e "\n------------------------------------------------"
echo "Mounting boot partition"
efi_directory="/boot/efi/"

if [ ! -d "$efi_directory" ]; then
  mkdir -p "$efi_directory"
fi
mount "$boot_partition" "$efi_directory"

echo "Creating initramfs..."
mkinitcpio -P

echo "Installing grub boot loader in $efi_directory"
grub-install --target=x86_64-efi --efi-directory=$efi_directory --bootloader-id=Arch --removable
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\n------------------------------------------------"
echo "Enabling NetworkManager..."
systemctl enable NetworkManager

echo -e "\n------------------------------------------------"
echo "Enter password for root user:"
passwd

read -p "Enter additional user name to add: " username
useradd -m -G wheel $username

echo "Enter password for ${username}: "
passwd $username

echo "Adding $username access to sudo"
sed -i '/^# %wheel ALL=(ALL:ALL) ALL/s/^# //g' /etc/sudoers

echo -e "\n------------------------------------------------"
echo "Deleting myself..."
# rm ek-arch-post-install.sh
