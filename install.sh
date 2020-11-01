#!/bin/sh
# usage : source install.sh
dotfiles=(.vimrc .zshrc .bashrc .gitconfig)
for i in "${dotfiles[@]}"
do
	ln -snfv $HOME/dotfiles/$i $HOME/$i
done
