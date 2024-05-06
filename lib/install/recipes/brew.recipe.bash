#!/bin/bash

COMMON_INGREDIENTS=(
    "git"
    "curl"
    "file"
)
APT_INGREDIENTS=(
    "build-essential"
    "procps"
)
PACMAN_INGREDIENTS=(
    "base-devel"
    "procps-ng"
)

install_brew() {
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
}

common_recipe(){
    install_brew
}
