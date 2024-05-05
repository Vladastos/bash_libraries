#!/bin/bash

common_recipe(){
    local COMMON_INGREDIENTS=(
        "git"
    )
    install_packages "${COMMON_INGREDIENTS[@]}"
    echo "Hello World!"
}
apt_recipe(){
    echo "Apt"
}
pacman_recipe(){
    echo "Pacman"
}
export -f common_recipe apt_recipe pacman_recipe
