if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# フォルダ準備
export HOME=$HOME/users/tuyuri6ka
export PATH=$HOME:$PATH
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

zsh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
