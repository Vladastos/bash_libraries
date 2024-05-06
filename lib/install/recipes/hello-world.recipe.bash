#!/bin/bash
#This is a recipe.
#It is used to test the install script.
COMMON_INGREDIENTS=(
    "git"
)

hello-world_common_recipe(){
    echo "Hello World!"
}
hello-world_apt_recipe(){
    echo "You are using Apt"
}
hello-world_pacman_recipe(){
    echo "You are using Pacman"
}
