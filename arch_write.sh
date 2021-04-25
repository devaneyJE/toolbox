#!/bin/bash

sudo umount /dev/mmcblk0p1
sudo umount /dev/mmcblk0p2

echo -e "o\nw" | sudo fdisk /dev/mmcblk0

sudo rm $HOME/arch -r

mkdir $HOME/arch
mkdir $HOME/arch/boot
mkdir $HOME/arch/root

echo -e "n\np\n1\n\n+100M\nt\nc\nn\np\n2\n\n\nw" | sudo fdisk /dev/mmcblk0

sudo mkfs.vfat /dev/mmcblk0p1
echo "y" | sudo mkfs.ext4 /dev/mmcblk0p2

sudo mount /dev/mmcblk0p1 $HOME/arch/boot
sudo mount /dev/mmcblk0p2 $HOME/arch/root

sudo su <<HERE
tar zxvf $HOME/Files/linux/arch/ArchLinuxARM-rpi-4-latest.tar.gz -C $HOME/arch/root

mv $HOME/arch/root/boot/* $HOME/arch/boot

sync

umount $HOME/arch/boot
umount $HOME/arch/root
HERE

