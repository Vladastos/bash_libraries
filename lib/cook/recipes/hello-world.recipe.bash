#!/bin/bash
COMMON_INGREDIENTS=(
    "git"
)

common_recipe(){
    echo "Hello World!"
}
apt_recipe(){
    echo "You are using Apt"
}
pacman_recipe(){
    echo "You are using Pacman"
}

export -f common_recipe apt_recipe pacman_recipe
export -A COMMON_INGREDIENTS
