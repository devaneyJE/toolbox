#!/bin/bash

if [ $(id -u) = 0 ]; then
	echo -e "Do NOT run with sudo!"
	exit 1
fi

if [ $# -eq 0 ] || [ $# -gt 1 ]; then
	echo -e "Available options: \n \ncopy - copy existing system files to repo \nupdate - use repo to update system configurations"
	exit 1
fi

# program lists
config_dirs=( "bspwm" "dmenu" "fish" "kitty" "neofetch" "nvim" "polybar" "rofi" "sxhkd" )
homedir_dot=( ".bashrc" ".vimrc" ".tmux.conf" ".xinitrc" )


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

if [ -d $HOME/repos/devaneyJE/dotfiles/ ]; then
	echo -e "Dotfiles repo present. \n"
else
	mkdir -p $HOME/repos/devaneyJE/dotfiles/
	git clone https://github.com/devaneyJE/dotfiles.git $HOME/repos/devaneyJE/dotfiles/
	echo -e "Dotfiles repo cloned. \n"
fi
dot_dir=$HOME/repos/devaneyJE/dotfiles


if [ $1 == "copy" ];then
	# backups
	echo -e "Checking for backups... \n"

	if [ -d $bak_dir/dotfiles/ ]; then
		echo -e "Dotfiles backup found at $bak_dir/dotfiles..."
		cp -r $bak_dir/dotfiles/ $bak_dir/dotfiles.bak/
		echo -e "Secondary backup updated. \n"
	else
		cp -r $dot_dir $bak_dir
		echo -e "Dotfiles repo copied to $bak_dir \n"
	fi
	# copying dotfiles
	echo "Copying dotfiles:"
	## .config dirs
	for i in "${config_dirs[@]}"; do
		if [ -d $home_config_dir/$i/ ] && [ -d $dot_dir/config/$i/ ]; then
			cp -r $home_config_dir/$i/* $dot_dir/config/$i/
			echo "$i"
			echo ' '
		elif [ -d $home_config_dir/$i/ ] && [ ! -d $dot_dir/config/$i/ ]; then
		    mkdir -p $dot_dir/config/$i/
			echo -e "$dot_dirconfig/$i/ created"
			cp -r $home_config_dir/$i/* $dot_dir/config/$i/
			echo "$i"
			echo ' '
		fi
	done
	## homedir dotfiles
	for i in "${homedir_dot[@]}"
	do
		if [ -e $HOME/$i ]; then
			cp $HOME/$i $dot_dir
			echo "$i"
			echo ' '
		else
			continue
		fi
	done
	echo -e " "
	echo -e "System configuration files copied to repo."

elif [ $1 == "update" ]; then
	#backups
	echo -e "Checking for backups... \n"

	if [ -d $bak_dir/home_config/ ]; then
		echo -e "Backup location found at $bak_dir/home_config. \nBacking up configurations... \n"
		# config
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
		# homedot
		for i in "${homedir_dot[@]}"; do
			if [ -e $HOME/$i ]; then
				cp $HOME/$i $bak_dir/home_config/
				echo -e "$i"
				echo ' '
			else
				continue
			fi
		done
		cp -r $bak_dir/home_config/ $bak_dir/home_config.bak/
		echo -e " "
		echo -e "Secondary backup updated. \n"
	else
		#mkdir -p $bak_dir/home_config/
		echo -e "Backup location created at $bak_dir/home_config. \nBacking up configurations... \n"
		#config
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
		# homedot
		for i in "${homedir_dot[@]}"; do
			if [ -e $HOME/$i ]; then
				cp $HOME/$i $bak_dir/home_config/
				echo -e "$i"
				echo ' '
			else
				continue
			fi
		done
		cp -r $bak_dir/home_config/ $bak_dir/home_config.bak/
		echo -e "Secondary backup updated. \n"
	fi

	# updating dotfiles
	echo "Updating dotfiles:"
	## .config dirs
	for i in "${config_dirs[@]}"; do
		if [ -d $home_config_dir/$i/ ]
		then
			cp -r $dot_dir/config/$i/* $home_config_dir/$i/
			echo "$i"
			echo ' '
		fi
	done
	## homedir dotfiles
	for i in "${homedir_dot[@]}"
	do
		if [ -e $HOME/$i ]; then
			cp $dot_dir/$i $HOME
			echo "$i"
			echo ' '
		else
			continue
		fi
	done
	echo -e " "
	echo -e "Repo files copied to system configurations."

else
	echo -e "Available options: \n \ncopy - copy existing system files to repo \nupdate - use repo to update system configurations"
fi
