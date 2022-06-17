#!/bin/bash

# prepare rust tool install
sudo apt install clang

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rustup install stable
rustup default stable

source "$HOME/.cargo/env"

# rust tool install
cargo install sd
cargo install bat
cargo install exa
cargo install ytop
cargo install procs
cargo install du-dust
cargo install fd-find
cargo install ripgrep
cargo install hyperfine
#cargo install cargo-update
