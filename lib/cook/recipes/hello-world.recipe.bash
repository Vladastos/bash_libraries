#!/bin/bash
RECIPE_DEPENDENCIES=(
    "git"
    )

common_recipe(){
    echo "Hello World!"
}
apt_recipe(){
    echo "Apt"
}
pacman_recipe(){
    echo "Pacman"
}
export -f common_recipe apt_recipe pacman_recipe
