#!/bin/bash
set -eu

e_newline() {
    printf "\n"
}

e_error() {
    printf " \033[31m%s\033[m\n" "✖ $*" 1>&2
}

e_done() {
    printf " \033[32;1m%s\033[m...\033[32mOK\033[m\n" "✔ $
*"
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

e_install() {
    file=$1
    e_newline && e_header "$file install start..."
    /bin/bash ./$file
    e_success "$file"
}

e_header "Bundles install start."

# install するものはファイルを用意し、ここにファイルを追加する。
e_install "rust_tools.sh"
e_install "deno.sh"
e_install "fzf.sh"
e_install "zinit.sh"
e_install "vim-plug.sh"
e_install "powerlevel-10k.sh"

e_done "Bundled install"
