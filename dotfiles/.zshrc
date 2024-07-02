## ----------------------------------------
## powerlevel10k setting part1
## Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
## Initialization code that may require console input (password prompts, [y/n]
## confirmations, etc.) must go above this block; everything else may go below.
## ----------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

cd $HOME

## ----------------------------------------
## PATH
## ----------------------------------------
export PATH=$HOME/bin:$PATH
export PATH=.:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/sbin:$PATH

## ----------------------------------------
##	Env
## ----------------------------------------
export EDITOR=vim
export CVS_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

## ----------------------------------------
## Zsh config
## ----------------------------------------
export HISTSIZE=100      # ヒストリーサイズ設定
export SAVEHIST=10000
export HISTFILE=${HOME}/.zsh_history
export FPATH="${HOME}/.zsh/completion:${FPATH}"

# zsh 補完の色分け用
## zsh で何色使えるかを確認するコマンド
## for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

setopt no_beep          # beep音を鳴らさない
setopt globdots         # タブキーで自動的に補完
setopt mark_dirs        # ファイル名の展開でディレクトリにマッチした場合末尾に/を付加する
setopt list_packed      # 補完候補を詰めて表示
setopt no_flow_control
setopt auto_param_keys
setopt auto_pushd       # 普通のcdでもスタックに入れる
setopt auto_list         # 曖昧な補完で自動的に選択肢をリストアップ
setopt auto_menu         # タブキーで自動的に保管
setopt share_history     # ヒストリーを共有
setopt auto_param_slash  # ディレクトリを補完すると自動的に末尾にスラッシュになる
setopt magic_equal_subst

#autoload -Uz colors && colors
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload -Uz compinit && compinit -i && compinit

zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:default' list-colors ${LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

## ----------------------------------------
## Keymap
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
## Alias & Function
## ----------------------------------------
alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g X='| xargs'
alias -g C='| wc -l'
alias -g L='| less S'

alias vi='vi'
alias vim='vim'
alias weather='curl -Acurl wttr.in/Tokyo'

alias g='git' && compdef _git g
alias cdg='cd `git rev-parse --show-toplevel`'

function tz()   { tar -zcvf ${1}.tar.gz ${1}; }
function absp() { echo $(cd $(dirname "$0") && pwd -P)/$(basename "$1"); }
function lnsv() { # enhancement of ln
	[ -z "$2" ] && echo "Specify Target" && return 0;
	abspath=$(absp $1);
	ln -sfnv "${abspath}" "$2";
}

## ----------------------------------------
## 外部ツール Alias & Function
## ----------------------------------------
alias hf='hyperfine --max-runs 3'
alias rg='rg --hidden -g "!.git" -g "!node_modules" --max-columns 200' rgi='rg -i'
alias bat='bat --color=always --style=header,grid'
alias dus='dust -pr -d 2 -X ".git" -X "node_modules"'
alias psa='ps aux' pskl='psa | fzf | awk "{ print \$2 }" | xargs kill -9'
alias fd='fd -iH --no-ignore-vcs -E ".git|node_modules"' rmds='fd .DS_Store -X rm'
alias ll='eza -alhF --group-directories-first --time-style=long-iso --ignore-glob=".git|node_modules"'
alias tr2='ll -T -L=2'
alias tr3='ll -T -L=3'

function fdsd() { fd "$1" | xargs sd "$2" "$3"; }
function rgr()  { rg --files-with-matches "$1" | xargs sd "$1" "$2"; }
function rgf()  {
	[ -z "$2" ] && matches=`rgi "$1"` || matches=`rg --files | rgi "$1"`;
	[ -z "${matches}" ] && echo "no matches\n" && return 0;
	selected=`echo "${matches}" | fzf --preview 'rgi -n "$1" {}'`;
	[ -z "${selected}" ] && echo "fzf Canceled." && return 0;
	vi "${selected}";
}

## ----------------------------------------
##	FZF
## ----------------------------------------
export ENHANCD_FILTER=fzf;
export ENHANCD_COMMAND=ecd
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_DEFAULT_OPTS='--reverse --color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229 --color info:150,prompt:110,spinner:150,pointer:167,marker:174'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## ----------------------------------------
##	Zinit
## ----------------------------------------
# Zinit install
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zinit Plugins
zinit load zdharma-continuum/history-search-multi-word
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit load babarot/enhancd;

# Zinit snnipet: 既存の alias 設定などを上書きしてしまうのでコメントアウト
# 各種参考になる書き方はある
# zinit snippet https://gist.githubusercontent.com/hightemp/5071909/raw/

# Default:
#  Load a few important annexes, without Turbo
#  (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# End of Zinit's installer chunk
source $HOME/.local/share/zinit/plugins/romkatv---powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/dotfiles/dotfiles/.p10k.zsh.
[[ ! -f ~/dotfiles/dotfiles/.p10k.zsh ]] || source ~/dotfiles/dotfiles/.p10k.zsh
