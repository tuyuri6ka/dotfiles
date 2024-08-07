#!/bin/bash

set -eu

## ----------------------------------------
##  Dotfiles
## ----------------------------------------

#DOTFILES_GITHUB="git@github.com:tuyuri6ka/dotfiles.git"
DOTFILES_GITHUB="https://github.com/tuyuri6ka/dotfiles.git"

dotfiles_logo='
      | |     | |  / _(_) |
    __| | ___ | |_| |_ _| | ___  ___
   / _` |/ _ \| __|  _| | |/ _ \/ __|
  | (_| | (_) | |_| | | | |  __/\__ \
   \__,_|\___/ \__|_| |_|_|\___||___/
'


if [ -z "${MYHOME:-}" ]; then
	MYHOME=$HOME/users/tuyuri6ka
	export HOME=$MYHOME
	export MYHOME
fi

# Set DOTPATH as default variable
# -z: defined check
if [ -z "${DOTPATH:-}" ]; then
    DOTPATH=$HOME/dotfiles; export DOTPATH
fi

echo "MYHOME: ${MYHOME}"
echo "HOME:   ${HOME}"
echo "DOTPATH:${DOTPATH}"

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
		git clone --recursive "$DOTFILES_GITHUB" "$DOTPATH"
		e_success "git clone"
	else
		e_error "Sorry. Please install git..."
		exit 1
	fi

	e_done "Download finished"
}

dotfiles_symlink () {
	e_newline
	e_header "Make symbolic link for dotfiles..."

	CWD=$DOTPATH
	if [ ! -d "$CWD" ]; then
		e_error "$CWD: not found"
		exit 1
	fi

	if ! is_exists "realpath"; then
		e_error "Sorry. Please install realpath..."
		exit 1
	fi

	cd $DOTPATH/dotfiles
	dot_list=$(ls -a | xargs realpath | grep -v "dotfiles$" | sort)

	cd $HOME
	for abspath in ${dot_list}; do
		relpath=$(basename ${abspath})
		ln -sfnv "${abspath}" "${relpath}"
	done

	e_done "Make symbolic link for dotfiles"
}

install_bundles() {
	e_newline
	e_header "Install bundles..."

	CWD=$DOTPATH/bundles
	if [ ! -d "$CWD" ]; then
		e_error "$CWD: not found"
	fi

	cd $CWD && /bin/bash ./install.sh

	e_newline && e_done "Install bundles"
}

dotfiles_clean () {
	e_newline
	e_header "Dotfiles symbolic link delete..."

	CWD=$DOTPATH
	if [ ! -d "$CWD" ]; then
		e_error "$CWD: not found"
		exit 1
	fi

	if ! is_exists "realpath"; then
		e_error "Sorry. Please install realpath..."
		exit 1
	fi

	cd $DOTPATH/dotfiles
	dot_list=$(ls -a | xargs realpath | grep -v "dotfiles$" | sort)

	cd $HOME
	for abspath in ${dot_list}; do
		relpath=$(basename ${abspath})
		unlink "${relpath}"
	done

	e_warning "dotfiles direcotry is left. If needed, please delete .dotfiles directory."
}

usage() {
	help='
  *** WHAT IS INSIDE? ***
  1. Download git repository
  2. Symlinking dotfiles to your home directory
  3. Execute all sh files within `etc/init/` (optional)

  Options for install.sh
  =================================================
   --download: Download git repository and make ~/.dotfiles dir
   --dotfiles: Make symbolic link from ~/.dotfiles to your home dir
   --bundles: Install bundles for various usefull tools
   --clean: Remove dotfiles symbolic link
   --all: All installations (except init)"
	'
	echo "${dotfiles_logo}"
	echo "${help}"
}


## ----------------------------------------
##  Main
## ----------------------------------------

echo "$dotfiles_logo"
if [[ $# -eq 0 ]]; then
	dotfiles_download &&
	dotfiles_symlink &&
	install_bundles
	exit 0
fi

read -p "Your file will be overwritten. OK? (Y/n: " Ans
if [[ $Ans != 'Y' ]]; then
	e_error 'Cancelled dotfiles installation'
	exit 1
fi

args=$@
for opt in ${args[@]}; do
	case $opt in
		--help) usage ;;
		--download) dotfiles_download ;;
		--dotfiles) dotfiles_symlink ;;
		--bundles) install_bundles ;;
		--clean) dotfiles_clean ;;
		--all)
			# Download the repository
			# ==> downloading
			dotfiles_download &&
			# Make dotfiles symlink to your home direcotry
			# ==> deploying
			dotfiles_symlink &&
			# Basic tool install and setting
			# Execute all sh files within bundles
			# ==> install usefull tools
			install_bundles
			;;
		*) e_error "invalid option $1" ;;
	esac
done;

# __END__
