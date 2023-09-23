# EK-Arch-Vanilla
Simple script to install vanilla version of Arch Linux. I wrote it for my own needs,  
but maybe it will be useful to someone else. What is important is that there are  
no additional things here, it is a good starting point for configuring or testing  
your own version of Arch for example with the windows manager of your choice.

## Important:
- Before using it, you must have root and boot partitions created,
- Use at your own risk ;)

## What is included
After installation you will have:
- grub, 
- efibootmgr, 
- vim, 
- networkmanager, 
- os-prober, 
- man, 
- sudo

And root filesystem on ext4.
During installation you will have option to install additional packages  
lvm2 and ntfs-3g, but for now it's all.

## Instructions
1. Prepare bootable USB drive with Arch Linux
2. Boot your computer from USB drive
3. Configure your internet connection (if you need it)
4. Install git and glibc (if it's needed)
```bash
pacman -Sy
```
```bash
pacman -S git glibc
```
5. Clone my repository:
```bash
git clone https://github.com/KlapenHz/MyArch.git
```
6. Run `ek-arch-base-install.sh` script
```bash
cd MyArch
chmod +x ek-arch-*-install.sh
./ek-arch-base-install.sh
```
7. Follow the instructions, **pay attention to the choice of filesystem for installation.**
8. After installation you should update grub entries (if it's not starting)
[wiki.archlinux.org - GRUB configuration](https://wiki.archlinux.org/title/GRUB#Configuration)
