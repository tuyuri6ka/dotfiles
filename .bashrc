if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export HOME=/home/motoike
export PATH=$HOME/.cargo/bin:$PATH

zsh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
