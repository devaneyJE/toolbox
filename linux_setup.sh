#! /bin/bash

# conditions to start running setup

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

#setting vars if tests pass
su=$SUDO_USER
homedir=/home/$su
todo=$homedir/.setup_todo.txt

# installing packages/acquiring repos
apt-get update -qq && apt-get install -qq vim git -y

echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\nPackages installed!\n--------------------\n -\n  -\n   -\n    -\n     -\n"

## making repos dir and cloning dirs
mkdir -p $homedir/{wlist,repos/{seclists,devaneyJE}}
git clone --quiet --depth 1 https://github.com/danielmiessler/SecLists.git $homedir/repos/seclists >/dev/null
mv $homedir/repos/seclists/{Discovery/Web-Content/{big.txt,directory-list-2.3-medium.txt},Passwords/Leaked-Databases/rockyou.txt.tar.gz,Fuzzing/SQLi/quick-SQLi.txt} $homedir/wlist/
tar -zxf $homedir/wlist/rockyou.txt.tar.gz -C $homedir/wlist/ && rm $homedir/wlist/rockyou.txt.tar.gz
cp -r /media/sf_VMShare/{dotfiles,toolbox} $homedir/repos/devaneyJE/
echo "- create and add ssh keys" >> $todo
echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\nRepositories created!\n--------------------\n -\n  -\n   -\n    -\n     -\n"

## copying vimrc
if [ -d $homedir/repos/devaneyJE/dotfiles ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git $homedir/.vim/bundle/Vundle.vim 
	chown $su:$su $homedir/.vim
	cp $homedir/repos/devaneyJE/dotfiles/vimrc $homedir/.vimrc
	vim +PluginInstall +qall
else
	echo -e "set nu\nset rnu\nset colo elflord" > $homedir/.vimrc	
fi 

echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\n$su .vimrc configured!\n--------------------\n -\n  -\n   -\n    -\n     -\n"

# adding to bashrc
cat $homedir/repos/dotfiles/bashrc_additions >> $homedir/.bashrc
echo -e " \n \ncat $todo" >> $homedir/.bashrc

echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\n$su .bashrc configured!\n--------------------\n -\n  -\n   -\n    -\n     -\n"

# create manual todo list
echo -e "Manual Setup ToDo List:\n" >> $todo
echo "- add '$su ALL=(ALL) NOPASSWD: ALL' to sudoers file" >> $todo
echo "- change terminal color settings" >> $todo
echo "- remove todo list reference from .bashrc" >> $todo

echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\nToDo List created!\n--------------------\n -\n  -\n   -\n    -\n     -\n"

chown -hR $su:$su $homedir

echo -e "\n     -\n    -\n   -\n  -\n -\n--------------------\n$homedir file ownership adjusted for $su!\n--------------------\n -\n  -\n   -\n    -\n     -\n"

cat $todo
