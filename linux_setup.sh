#! /bin/bash

# conditions to start running setup
if [ $# -eq 0 ] 
then
	echo "Missing options! Use -h for help."
	exit 1
fi

if [ $1 == "-h" ]; then
	echo -e "Syntax:\nlinux_setup.sh -u <user> <ssh-option>"
	exit 1
fi

if ! [ $(id -u) = 0 ]; then
	echo "Run script with sudo..."
	exit 1
fi

if [ $1 == "-u" && ! -d /home/$2 ]; then
	echo "User does not exist or have necessary home directory."
	exit 1
fi

#setting vars if tests passed
homedir=/home/$2
todo=$homedir/.setup_todo.txt
echo "Manual Setup ToDo List:" >> $todo

# installing software/acquiring repos
if ! [ -x "$(command -v vim)" ]; then
	apt-get update
	apt-get install vim -y
fi
if ! [ -x "$(command -v git)" ]; then
	apt-get update
	apt-get install git -y
fi

## making repos dir and cloning dirs
mkdir -p $homedir/{wlist,repos/seclists}
git clone --depth 1 https://github.com/danielmiessler/SecLists.git $homedir/repos/seclists
mv $homedir/repos/seclists/{Discovery/Web-Content/{big.txt,directory-list-2.3-medium.txt},Passwords/Leaked-Databases/rockyou.txt.tar.gz,Fuzzing/SQLi/quick-SQLi.txt} $homedir/wlist/
tar -zxf $homedir/wlist/rockyou.txt.tar.gz -C $homedir/wlist/ && rm $homedir/wlist/rockyou.txt.tar.gz

if [ $3 == "-ssh" ]; then
	mkdir -p $homedir/repos/devaneyJE/{dotfiles,toolbox}
	git clone git@github.com:devaneyJE/dotfiles.git $homedir/repos/devaneyJE/dotfiles
	git clone git@github.com:devaneyJE/toolbox.git $homedir/repos/devaneyJE/toolbox
else
	echo "create and add ssh keys" >> $todo
fi

## copying vimrc
if [ -d $homedir/repos/devaneyJE/dotfiles ]; then
	cp $homedir/dotfiles/vimrc $homedir/.vimrc
	vim +PluginInstall +qall
else
	echo -e "set nu\nset rnu\nset colo elflord" > $homedir/.vimrc	
fi

# adding to bashrc
echo " " >> $homedir/.bashrc
echo " " >> $homedir/.bashrc
echo " " >> $homedir/.bashrc

## general
echo "# user mods below" >> $homedir/.bashrc
echo "cat $todo" >> $homedir/.bashrc
echo -e "export VISUAL=vim\nexport EDITOR=$VISUAL" >> $homedir/.bashrc
echo " " >> $homedir/.bashrc

## path edit
echo "## adding dirs to path" >> $homedir/.bashrc

if [ -d $homedir/scripts ]; then
	echo 'export PATH="$HOME/scripts:$PATH"' >> $homedir/.bashrc
else
	mkdir $homedir/scripts
	echo 'export PATH="$HOME/scripts:$PATH"' >> $homedir/.bashrc
fi	

if [ -d $homedir/repos/devaneyJE/toolbox ]; then
	echo 'export PATH="$HOME/repos/devaneyJE/toolbox:$PATH"' >> $homedir/.bashrc
fi

if [ -d $homedir/go ]; then
	echo 'export PATH="$HOME/go/bin:$PATH"' >> $homedir/.bashrc
fi
echo " " >> $homedir/.bashrc

## aliases
echo "## aliases" >> $homedir/.bashrc 
echo "alias vibashrc='vim $homedir/.bashrc'" >> $homedir/.bashrc
echo 'alias sudos='sudo env PATH=$PATH'' >> $homedir/.bashrc
echo " " >> $homedir/.bashrc

# create manual todo list
echo "add `'admin-user' ALL=(ALL) NOPASSWD: ALL` to sudoers file" >> $todo
echo "change terminal color settings" >> $todo
echo "remove todo list reference from .bashrc" >> $todo

