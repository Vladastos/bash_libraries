#!/bin/bash
COMMON_INGREDIENTS=(
    "git"
    "brew"
    )
neovim_common_recipe(){
    if ! command -v nvim &> /dev/null; then
        brew install neovim
    fi
}
