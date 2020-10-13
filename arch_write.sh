#!/bin/bash

sudo umount /dev/mmcblk0p1
sudo umount /dev/mmcblk0p2

echo -e "o\nw" | sudo fdisk /dev/mmcblk0

sudo rm /home/jonah/arch -r

mkdir /home/jonah/arch
mkdir /home/jonah/arch/boot
mkdir /home/jonah/arch/root

echo -e "n\np\n1\n\n+100M\nt\nc\nn\np\n2\n\n\nw" | sudo fdisk /dev/mmcblk0

sudo mkfs.vfat /dev/mmcblk0p1
echo "y" | sudo mkfs.ext4 /dev/mmcblk0p2

sudo mount /dev/mmcblk0p1 /home/jonah/arch/boot
sudo mount /dev/mmcblk0p2 /home/jonah/arch/root

sudo su <<HERE
tar zxvf /home/jonah/Files/linux/arch/ArchLinuxARM-rpi-4-latest.tar.gz -C /home/jonah/arch/root

mv /home/jonah/arch/root/boot/* /home/jonah/arch/boot

sync

umount /home/jonah/arch/boot
umount /home/jonah/arch/root
HERE

