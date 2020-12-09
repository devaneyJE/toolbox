#! /bin/bash

# conditions to start running setup
#if [ $# -eq 0 ] 
#then
#	echo "Missing options! Use -h for help."
#	exit 1
#fi

if [ $# == 1 ] && [ $1 == "-h" ]; then
	echo -e "Syntax:\n./linux_setup.sh"
	exit 1
fi

if ! [ $(id -u) = 0 ]; then
	echo "Run script with sudo..."
	exit 1
fi

if [ ! -d /home/$SUDO_USER ]; then
	echo "User does not exist or have necessary home directory."
	exit 1
fi

echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\nStarting Setup!\n--------------------\n -\n  -\n   -\n    -\n     -\n"

#setting vars if tests passed
su=$SUDO_USER
homedir=/home/$su
todo=$homedir/.setup_todo.txt
echo -e "Manual Setup ToDo List:\n" >> $todo
chown $su:$su $todo

# installing software/acquiring repos
if ! [ -x "$(command -v vim)" ]; then
	apt-get update -qq
	apt-get install -qq vim -y
fi
if ! [ -x "$(command -v git)" ]; then
	apt-get update -qq
	apt-get install -qq git -y
fi
echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\nSoftware installed!\n--------------------\n -\n  -\n   -\n    -\n     -\n"

## making repos dir and cloning dirs
mkdir -p $homedir/{wlist,repos/{seclists,devaneyJE}}
git clone --quiet --depth 1 https://github.com/danielmiessler/SecLists.git $homedir/repos/seclists >/dev/null
mv $homedir/repos/seclists/{Discovery/Web-Content/{big.txt,directory-list-2.3-medium.txt},Passwords/Leaked-Databases/rockyou.txt.tar.gz,Fuzzing/SQLi/quick-SQLi.txt} $homedir/wlist/
tar -zxf $homedir/wlist/rockyou.txt.tar.gz -C $homedir/wlist/ && rm $homedir/wlist/rockyou.txt.tar.gz
cp -r /media/sf_VMShare/{dotfiles,toolbox} $homedir/repos/devaneyJE/
echo "- create and add ssh keys" >> $todo
chown -R $su:$su $homedir/{wlist,repos}
echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\nRepositories created!\n--------------------\n -\n  -\n   -\n    -\n     -\n"

## copying vimrc
if [ -d $homedir/repos/devaneyJE/dotfiles ]; then
	git clone --quiet https://github.com/VundleVim/Vundle.vim.git $homedir/.vim/bundle/Vundle.vim >/dev/null
	chown $su:$su $homedir/.vim
	cp $homedir/repos/devaneyJE/dotfiles/vimrc $homedir/.vimrc
	vim +PluginInstall +qall
else
	echo -e "set nu\nset rnu\nset colo elflord" > $homedir/.vimrc	
fi 
echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\n$su .vimrc configured!\n--------------------\n -\n  -\n   -\n    -\n     -\n"

# adding to bashrc
echo " " >> $homedir/.bashrc
echo " " >> $homedir/.bashrc
echo " " >> $homedir/.bashrc

## general
echo "# user mods below" >> $homedir/.bashrc
echo "cat $todo" >> $homedir/.bashrc
echo 'export VISUAL=vim' >> $homedir/.bashrc
echo 'export EDITOR=$VISUAL' >> $homedir/.bashrc
echo " " >> $homedir/.bashrc

## path edit
echo "## adding dirs to path" >> $homedir/.bashrc

if [ -d $homedir/scripts ]; then
	echo 'export PATH="$HOME/scripts:$PATH"' >> $homedir/.bashrc
else
	mkdir $homedir/scripts
	chown $su:$su $homedir/scripts
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
echo "## user aliases" >> $homedir/.bashrc 
echo "alias vibashrc='vim $homedir/.bashrc'" >> $homedir/.bashrc
echo 'alias sudos='sudo env PATH=$PATH'' >> $homedir/.bashrc
echo " " >> $homedir/.bashrc
echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\n$su .bashrc configured!\n--------------------\n -\n  -\n   -\n    -\n     -\n"

# create manual todo list
echo "- add '$su ALL=(ALL) NOPASSWD: ALL' to sudoers file" >> $todo
echo "- change terminal color settings" >> $todo
echo "- remove todo list reference from .bashrc" >> $todo
echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\nToDo List created!\n--------------------\n -\n  -\n   -\n    -\n     -\n"
cat $todo
