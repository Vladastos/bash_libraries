#!/bin/bash

get_recipe_dependencies(){
    local RECIPE_DEPENDENCIES=(
        "git"
    )
    local PACMAN_DEPENDENCIES=(
        "base-devel"
    )
    local APT_DEPENDENCIES=(
        "build-essential"
    )
    export RECIPE_DEPENDENCIES PACMAN_DEPENDENCIES APT_DEPENDENCIES
}
common_recipe(){
    echo "Hello World!"
}
apt_recipe(){
    echo "Apt"
}
pacman_recipe(){
    echo "Pacman"
}

get_recipe_dependencies
