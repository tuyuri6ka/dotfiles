if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export PATH=$HOME/.cargo/bin:$PATH

zsh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
