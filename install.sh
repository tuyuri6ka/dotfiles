#!/bin/bash

set -eu

## ----------------------------------------
##  Dotfiles
## ----------------------------------------

DOTFILES_GITHUB="hoge"

dotfiles_logo='
      | |     | |  / _(_) |
    __| | ___ | |_| |_ _| | ___  ___
   / _` |/ _ \| __|  _| | |/ _ \/ __|
  | (_| | (_) | |_| | | | |  __/\__ \
   \__,_|\___/ \__|_| |_|_|\___||___/
'

# Set DOTPATH as default variable
# -z: defined check
if [ -z "${DOTPATH:-}" ]; then
    DOTPATH=~/.dotfiles; export DOTPATH
fi

## ----------------------------------------
##  Function
## ----------------------------------------

e_newline() {
	printf "\n"
}

e_error() {
	printf " \033[31m%s\033[m\n" "✖ $*" 1>&2
}

e_done() {
	printf " \033[32;1m%s\033[m...\033[32mOK\033[m\n" "✔ $*"
}

e_success() {
	printf " \033[37;1m%s\033[m...\033[32mOK\033[m\n" "➜ $*"
}

e_warning() {
	printf " \033[31m%s\033[m\n" "$*"
}

e_header() {
	printf " \033[37;1m%s\033[m\n" "$*"
}

is_exists() {
	which "$1" > /dev/null 2>&1
	return $?
}

# make .dotfiles in your home directory and download git repository
dotfiles_download () {
	# -d: directory check
	if [ -d "$DOTPATH" ]; then
		e_error "$DOTPATH: already exists"
		exit 1
	fi

	e_newline
	e_header "Downloading dotfiles..."

	if is_exists "git"; then
		#git clone --recursive "$DOTFILES_GITHUB" "$DOTPATH"
		e_success "git clone"

	elif is_exists "curl" || is_exists "wget"; then
		# curl or get
		local tarball=""
		if is_exists "curl"; then
			#curl -L "$tarball"
			e_success "curl"
		elif is_exists "wget"; then
			#curl -O - "$tarball"
			e_success "wget"
		fi #| tar xvz ## pipe

		if [ ! -d dotfiles-master ]; then
			e_error "dotfiles-master: not found"
			exit 1
		fi

		echo "command"
		#command mv -f dotfiles-master "$DOTPATH"
	else
		e_error "Sorry. Please install curl or wget..."
		exit 1
	fi

	e_done "Download finished"
}

dotfiles_deploy () {
	e_newline
	e_header "Deploying dotfiles..."

	if [ ! -d "$DOTPATH" ]; then
		e_error "$DOTPATH: not found"
		exit 1
	fi

	cd "$DOTPATH"

	make deploy && e_done "Deploy"
}

dotfiles_initialize () {
	e_newline
	e_header "Initializing dotfiles..."

	if [ "$1" = "--init" ]; then
		if [ -f Makefile ]; then
			make init
		else
			e_error "Makefile: not found"
			exit 1
		fi
		e_newline && e_done "Initialize"
	else
		e_warning "if you also want to initilaize, please set option --init"
		e_newline && e_done "Initilize skip"
	fi
}

# Script for the file named "install"
dotfiles_install() {
	# Download the repository
	# ==> downloading
	dotfiles_download &&

	# Deploy dotfiles to your home direcotry
	# ==> deploying
	dotfiles_deploy &&

	# Execute all sh files within etc/init/
	# ==> initialize
	dotfiles_initialize "$@"
}

usage() {
	help='
  *** WHAT IS INSIDE? ***
  1. Download git repository
  2. Symlinking dotfiles to your home directory
  3. Execute all sh files within `etc/init/` (optional)

  Options for install.sh
  =================================================
  --init: Execute all sh files within`etc/init/`
	'
	echo "${dotfiles_logo}"
	echo "${help}"
}


## ----------------------------------------
##  Main
## ----------------------------------------

args=$@
if [[ ${args[@]} =~ "--help" || $# -eq 0 ]]; then
	usage
	exit 0
fi

read -p "Your file will be overwritten. OK? (Y/n: " Ans
if [[ $Ans != 'Y' ]]; then
	e_error 'Cancelled dotfiles installation'
	exit 1
fi

echo "$dotfiles_logo"
dotfiles_install "$@"

# __END__
