## ----------------------------------------
##	powerlevel10k setting
##	- Must be the top of .zshrc
##	- p10k configure
## ----------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## ----------------------------------------
## Settings
## ----------------------------------------
export PATH=$HOME/bin:$PATH
export PATH=.:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

source ~/git-prompt.sh
source ~/.cargo/env

## ----------------------------------------
##	Env
## ----------------------------------------
export ENHANCD_FILTER=fzf
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

## ----------------------------------------
##	Editor
## ----------------------------------------
export EDITOR=vim
export CVSEDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"

## ----------------------------------------
##	Language
## ----------------------------------------
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

## ----------------------------------------
##	Option & Function
## ----------------------------------------
setopt no_beep
setopt globdots
setopt mark_dirs
setopt list_packed
setopt no_flow_control
setopt auto_param_keys
setopt auto_pushd
autoload -Uz colors && colors
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

## ----------------------------------------
##	Completion
## ----------------------------------------
setopt auto_list
setopt auto_menu
setopt share_history
setopt auto_param_slash
setopt magic_equal_subst
export HISTSIZE=100
export SAVEHIST=10000
export HISTFILE=${HOME}/.zsh_history
export FPATH="${HOME}/.zsh/completion:${FPATH}"
autoload -Uz compinit && compinit -i && compinit
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:default' list-colors ${LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

## ----------------------------------------
##	Keymap
## ----------------------------------------
bindkey '^F' forward-word
bindkey '^B' backward-word
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

## ----------------------------------------
##	Alias & Function
##	- ~/.aliases/**.zsh has more aliases which not often used.
## ----------------------------------------
alias vi='nvim'
alias vimvim='vim ~/.vimrc'
alias cdh='cd ~'
alias hf='hyperfine --max-runs 3'
alias weather='curl -Acurl wttr.in/Tokyo'
alias virc='vi ~/.zshrc' sorc='source ~/.zshrc'
alias op='open ./'
alias pp='pbpaste >'
alias cdwk='cd ~/work'
alias opg='hub browse'
alias opis='hub issue show `hub issue | fzf`'
alias oppr='hub pr show `hub pr list | fzf`'
alias copr='hub pr checkout `hub pr list | fzf`'

alias bat='bat --color=always --style=header,grid'
alias dus='dust -pr -d 2 -X ".git" -X "node_modules"'
alias python='/usr/local/bin/python3.8' py='python' pip='/usr/local/bin/pip3'
alias psa='ps aux' pskl='psa | fzf | awk "{ print \$2 }" | xargs kill -9'
alias fd='fd -iH --no-ignore-vcs -E ".git|node_modules"' rmds='fd .DS_Store -X rm'
alias rg='rg --hidden -g "!.git" -g "!node_modules" --max-columns 200' rgi='rg -i'
alias ll='exa -alhF --git-ignore --group-directories-first --time-style=long-iso --ignore-glob=".git|node_modules"' 
alias tr2='ll -T -L=2'
alias tr3='ll -T -L=3'

function vv() {
	[ -z "$1" ] && code -r ./ && return 0;
	code -r "$1";
}
function lnsv() { # enhancement of ln
	[ -z "$2" ] && echo "Specify Target" && return 0;
	abspath=$(absp $1);
	ln -sfnv "${abspath}" "$2";
}
function rgf()  {
	[ -z "$2" ] && matches=`rgi "$1"` || matches=`rg --files | rgi "$1"`;
	[ -z "${matches}" ] && echo "no matches\n" && return 0;
	selected=`echo "${matches}" | fzf --preview 'rgi -n "$1" {}'`;
	[ -z "${selected}" ] && echo "fzf Canceled." && return 0;
	vi "${selected}";
}
function cap()  { cat "$1" | pbcopy }
function fdsd() { fd "$1" | xargs sd "$2" "$3"; }
function rgr()  { rg --files-with-matches "$1" | xargs sd "$1" "$2"; }
function cmpr() { ffmpeg -i "$1" -vcodec h264 -acodec mp2 output.mp4; }
function absp() { echo $(cd $(dirname "$0") && pwd -P)/$(basename "$1"); }
function tz()   { tar -zcvf ${1}.tar.gz ${1}; }
function tunz() {
	case $1 in
	*.zip)     unzip    $1 ;;
	*.tgz)     tar xvzf $1 ;;
	*.tbz2)    tar xvjf $1 ;;
	*.tar)     tar xvzf $1 ;;
	*.tar)     tar xvzf $1 ;;
	*)         echo "Unable to extract '$1'" ;;
}

## ========== Global Alias ==========
alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g X='| xargs'
alias -g C='| wc -l'
alias -g L='| less S'
alias -g CP='| pbcopy'
alias -g AT='| as-tree'
alias -g TA='> ~/work/temp/a.log'
alias -g TB='> ~/work/temp/b.log'
alias dflg='delta ~/work/temp/a.log ~/work/temp/b.log'

## ========== Suffix Alias ==========
alias -s {png,jpg,jpeg}='imgcat'
alias -s {html,mp3,mp4,mov}='open'
alias -s {applescript}='osascript'

## ========== Git ==========
## - ~/.gitconfig has most of git aliases.
alias g='git' && compdef _git g
alias cdgh='cd `ghq list -p | fzf`'
alias cdg='cd `git rev-parse --show-toplevel`'
gcre() {
	[ -z "$(ls -A ./)" ] && echo "Fail: Directory is empty." && return 0;
	git init && git add -A && git commit;
	read        name"?type repo name        : ";
	read description"?type repo description : ";
	hub create ${name} -d ${description} -p;
	git push --set-upstream origin master;
	hub browse;
}

## Suffix Alias
alias -s {png,jpg,jpeg}='imgcat'

## Git
alias g='giy' && compdef _git g
alias cdg='cd `git rev-parse --show-toplevel`'

## ========== Tmux ==========
alias tm='tmux' && compdef _tmux tm
alias tmn='tm attach -t main || tmux new -s main'
alias tmkl='tmux list-sessions | fzf -m | cut -d: -f 1 | xargs -I{} tmux kill-session -t {}'
tmrn() {
	selected=`tmux list-sessions | fzf | cut -d : -f 1`
	read newname"?type new session name: ";
	tmux rename-session -t "${selected}" "${newname}"
}
tma() {
	selected=`tmux list-sessions | fzf | cut -d : -f 1`
	if [ -z "${TMUX}" ]; then
		tmux attach -t "${selected}"
	else
		tmux switch -t "${selected}"
	fi
}

## ========== Neovim ==========
alias vivi='vi ~/.config/nvim/init.vim'
vii() {
	nvim -c ":call Wal()" $@;
}
vink() {
	FORMAT=`nkf -g $@`;
	nvim -c ":e ++enc=${FORMAT}" $@;
}
vigo() {
	vi -c "call append(0, v:oldfiles)" -c "write! ~/.config/nvim/viminfo.log" -c exit;
	vi `cat ~/.config/nvim/viminfo.log | fzf --preview 'bat --color=always {}'`;
}

## ========== Aliases && Snippets ==========
[ -f ~/.secret_alias ] && source ~/.secret_alias
alias sotm='wal -i `ls -d ~/.pywal/* | fzf`'
alias visn='vi     `ls -d ~/.vsnip/*   | fzf --preview "bat --color=always {}"`'
alias vial='vi     `ls -d ~/.aliases/* | fzf --preview "bat --color=always {}"`'
alias soal='source `ls -d ~/.aliases/* | fzf --preview "bat --color=always {}"`'

## ----------------------------------------
##	FZF
## ----------------------------------------
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_DEFAULT_OPTS='--reverse --color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229 --color info:150,prompt:110,spinner:150,pointer:167,marker:174'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## ----------------------------------------
##	iTerm2
## ----------------------------------------
if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
	[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh
	alias imgcat='/usr/local/bin/imgcat'
fi

## ----------------------------------------
##	Gcloud
## ----------------------------------------
[ -f '${HOME}/google-cloud-sdk/path.zsh.inc' ] && source '${HOME}/google-cloud-sdk/path.zsh.inc'
[ -f '${HOME}/google-cloud-sdk/completion.zsh.inc' ] && source '${HOME}/google-cloud-sdk/completion.zsh.inc'

## ----------------------------------------
##	Zinit
## ----------------------------------------
## Install Zinit if not installed
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
	print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
	command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
	command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
		print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
		print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

# Zinit setting and install plugins
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit lucid for \
	b4b4r07/enhancd \
	zsh-users/zsh-completions \
	zsh-users/zsh-autosuggestions \
	zsh-users/zsh-syntax-highlighting \
	as'completion' is-snippet 'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \'
	as'completion' is-snippet 'https://github.com/docker/machine/blob/master/contrib/completion/zsh/_docker-machine' \'
	as'completion' is-snippet 'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose' \'

## ----------------------------------------
##	Prompt
##	- Must be the end of .zshrc.
##	- `p10k configure` to restart setting.
## ----------------------------------------
[ -f ~/.fzf.zdh ] && source ~/.fzf.zsh
[ -f ~/zsh/powerlevel10k/powerlovel10k.zsh-theme ] && source ~/zsh/powerlevel10k/powerlevel10k.zsh-theme
[[ ! ~/zsh/powerlevel10k/.p10k.zsh ]] || source ~/zsh/powerlevel10k/.p10k.zsh

### End of Zinit's installer chunk
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
