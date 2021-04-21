#!/bin/bash

if [ $(id -u) = 0 ]; then
	echo -e "Do NOT run with sudo!"
	exit 1
fi

# program list
config_dirs=( "bspwm" "dmenu" "feh" "fish" "kitty" "neofetch" "nvim" "polybar" "sxhkd" "vim" "xorg" )
#add shell, zsh above


# dir check
if [ -d $HOME/.bak/ ]; then
	echo -e "Backup directory present. \n"
else
	mkdir -p $HOME/.bak/
	echo -e "Backup directory created. \n"
fi
bak_dir=$HOME/.bak

if [ -d $HOME/.config/ ]; then
	echo -e ".config directory present. \n"
else
	mkdir -p $HOME/.config/
	echo -e ".config directory created. \n"
fi
home_config_dir=$HOME/.config

#if [ -d $HOME/repos/devaneyJE/dotfiles/ ]; then
#	echo -e "Dotfiles repo present. \n"
#else
#	mkdir -p $HOME/repos/devaneyJE/dotfiles/
#	git clone https://github.com/devaneyJE/dotfiles.git $HOME/repos/devaneyJE/dotfiles/
#	echo -e "Dotfiles repo cloned. \n"
#fi
dot_dir=$HOME/repos/dotfiles

# backup
for i in "${config_dirs[@]}"; do
	if [ -d $bak_dir/home_config/$i ]; then
		cp -r $home_config_dir/$i/* $bak_dir/home_config/$i/
		echo -e "$i"
		echo ' '
	else
		mkdir -p $bak_dir/home_config/$i
		cp -r $home_config_dir/$i/* $bak_dir/home_config/$i/
		echo -e "$i"
		echo ' '
	fi
done

# installing dotfiles
echo "Installing dotfiles:"
for i in "${config_dirs[@]}"; do
	if [ -d $home_config_dir/$i/ ]; then
		cp -r $dot_dir/.config/$i/ $home_config_dir/$i/
		echo "$i"
		echo ' '
	elif [ ! -d $home_config_dir/$i/ ]; then
		mkdir -p $home_config_dir/$i/
		cp -r $dot_dir/.config/$i/ $home_config_dir/$i/
		echo "$i"
		echo ' '
	fi
done

echo -e " "
echo -e "System configuration files installed from repo."

