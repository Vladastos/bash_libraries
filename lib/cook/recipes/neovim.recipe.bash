#!/bin/bash
local COMMON_INGREDIENTS=(
    "git"
    "brew"
    )
common_recipe(){
    install_packages "${COMMON_INGREDIENTS[@]}"
    brew install neovim
}
export -f common_recipe
export -A COMMON_INGREDIENTS
