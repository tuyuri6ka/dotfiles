#!/bin/bash

set -eu

## ----------------------------------------
##  Dotfiles
## ----------------------------------------

DOTFILES_GITHUB="git@github.com:tuyuri6ka/dotfiles.git"
#DOTFILES_GITHUB="https://github.com/tuyuri6ka/dotfiles.git"

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
		git clone --recursive "$DOTFILES_GITHUB" "$DOTPATH"
		e_success "git clone"

	elif is_exists "curl" || is_exists "wget"; then
		# curl or get
		local tarball=""
		if is_exists "curl"; then
			curl -L "$tarball"
			e_success "curl"
		elif is_exists "wget"; then
			curl -O - "$tarball"
			e_success "wget"
		fi | tar xvz ## pipe

		if [ ! -d dotfiles-master ]; then
			e_error "dotfiles-master: not found"
			exit 1
		fi

		echo "command"
		command mv -f dotfiles-master "$DOTPATH"
	else
		e_error "Sorry. Please install curl or wget..."
		exit 1
	fi

	e_done "Download finished"
}

dotfiles_symlink () {
	e_newline
	e_header "Make symbolic link for dotfiles..."

	CWD=$DOTPATH/dotfiles
	if [ ! -d "$CWD" ]; then
		e_error "$CWD: not found"
		exit 1
	fi

	handle_symlink_from_path() {
		file=$1
		dirpath=$(dirname "${file}") && filename=$(basename "${file}")
		abspath=$(cd "${dirpath}" && pwd)"/${filename}"
		relpath=$(echo "${file}" | sed "s|^\./dotfiles/||")
		target="${HOME}/${relpath}"
		mkdir -p "$(dirname "${target}")"
		ln -sfnv "${abspath}" "${target}"
	}
	export -f handle_symlink_from_path

	bulk_symlink_target=(
		"./dotfiles/.aliases"
		"./dotfiles/.git_template"
  	)

	find_exclude=""
	for i in "${bulk_symlink_target[@]}"; do
		handle_symlink_from_path "${i}"
		find_exclude="${find_exclude} -path \"${i}\" -prune -or "
	done
	find_command="find ./dotfiles ${find_exclude} \( -type l -or -type f \) -exec bash -c 'handle_symlink_from_path \"{}\"' \;"
	eval "${find_command}" && e_done "Make symbolic link for dotfiles"
}

setup_env () {
	e_newline
	e_header "Setup environment..."

	sudo apt update && e_success "apt update"
	sudo apt install zsh && e_success "zsh install"

	e_newline && e_done "Initialize"
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

	e_newline && e_done "Dotfiles symbolic link delete"

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
   --setup_env: Core Initilaization
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

for opt in ${args[@]}; do
	case $opt in
		--download) dotfiles_download ;;
		--dotfiles) dotfiles_symlink ;;
		--setup_env) setup_env ;;
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
			# ==> setup enviroment
			setup_env &&
			# Execute all sh files within bundles
			# ==> install usefull tools
			install_bundles
			;;
		*) e_error "invalid option $1" ;;
	esac
done;

# __END__
