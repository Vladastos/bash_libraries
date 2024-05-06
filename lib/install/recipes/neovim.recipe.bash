#!/bin/bash
local COMMON_INGREDIENTS=(
    "git"
    "brew"
    )
neovim_common_recipe(){
    install_packages "${COMMON_INGREDIENTS[@]}"
    brew install neovim
}
