#!/bin/bash
detect_package_manager() {
    if [ "$PACKAGE_MANAGER" ]; then
        return
    fi
    if [ -x "$(command -v apt-get)" ]; then
        PACKAGE_MANAGER="apt-get"
        return
    elif [ -x "$(command -v apt)" ]; then
        PACKAGE_MANAGER="apt"
        return
    elif [ -x "$(command -v pacman)" ]; then
        PACKAGE_MANAGER="pacman"
        return
    else
        PACKAGE_MANAGER="unknown"
    fi
}

construct_install_command() {
    if [ "$PACKAGE_MANAGER" == "brew" ]; then
        INSTALL_COMMAND="brew install"
    elif [ "$PACKAGE_MANAGER" == "apt" ]; then
        INSTALL_COMMAND="sudo apt install"
        if [ "$yes_flag" == true ]; then
            INSTALL_COMMAND="$INSTALL_COMMAND -y"
        fi
    elif [ "$PACKAGE_MANAGER" == "pacman" ]; then
        INSTALL_COMMAND="sudo pacman -S"
        if [ "$yes_flag" == true ]; then
            INSTALL_COMMAND="$INSTALL_COMMAND --noconfirm"
        fi
    else
        INSTALL_COMMAND="unknown"
        echo "Unknown package manager. Please install dependencies manually."
        exit 1
    fi
}
install_packages() {
    local packages=("$@")
    for package in "${packages[@]}"; do
        echo "Checking if $package is installed..."
        if ! command -v "$package" &> /dev/null; then
            # check if there is a recipe available for the package
            check_recipe "$package" | use_recipe "$package" && continue || return 1  
            echo "Installing $package..."
            bash -c "$INSTALL_COMMAND $package" && {
                echo "Successfully installed $package."
            } || return 4
        else
            echo "$package is already installed."
        fi
    done 
}


parse_args() {
    local args=("$@")
    for arg in "${args[@]}"; do
        if [ "$arg" == "-h" ] || [ "$arg" == "--help" ] || [ -z "$arg" ]; then
            echo "Usage: install [options] [package1 package2 ...]"
            echo "Options:"
            echo "  -h, --help  Show this help message"
            echo "  -y, --yes   Assume yes for all prompts"
            return 1
        fi
        if [ "$arg" == "-v" ] || [ "$arg" == "--version" ]; then
            echo "Using version: $COOK_VERSION"
            return 1
        fi
        if [ "$arg" == "-y" ] || [ "$arg" == "--yes" ]; then
            echo "Assuming yes for all prompts"
            yes_flag=true
            shift
        fi
    done
}

update_recipe_cache() {
    echo "Updating recipe cache..."

    if [ ! -d "$CACHE_DIR" ]; then
        mkdir -p "$CACHE_DIR"
    fi
    echo "" > "$RECIPE_LIST_FILE"
    wget -qO "$RECIPE_LIST_FILE" "$RECIPE_LIST_URL"
}

check_recipe() {
    local package="$1"
    source "$RECIPE_LIST_FILE"
    if [ -z "${RECIPE_LIST[$package]}" ]; then
        return 1
    fi
    echo "${RECIPE_LIST[$package]}"
}

use_recipe() {
    local recipe="$1"
    local RECIPE_URL="https://raw.githubusercontent.com/Vladastos/vlibs/main/lib/cook/recipes/${RECIPE_LIST[$recipe]}.recipe.bash"

    source <(curl -fsSL "$RECIPE_URL") || return 1

    echo "Getting ingredients for $recipe..."
    install_packages "${RECIPE_DEPENDENCIES[@]}" || return 1 

    echo "Following recipe for $recipe..."
    common_recipe
    "$PACKAGE_MANAGER"_recipe

    echo "$recipe has been cooked."
}

cook() {
    local COOK_VERSION="1.0.6d"
    local PACKAGE_MANAGER
    local CACHE_DIR="$HOME"/.cache/vlibs
    local RECIPE_LIST_FILE="$CACHE_DIR"/cook/recipe_list.bash
    local RECIPE_LIST_URL="https://raw.githubusercontent.com/Vladastos/vlibs/main/lib/cook/recipe_list.bash"

    local yes_flag=true

    parse_args "$@" || return 0
    detect_package_manager || {
        echo "Failed to detect package manager."
        return 1
    }
    construct_install_command || {
        echo "Failed to construct install command."
        return 2
    }
    update_recipe_cache || {
        echo "Failed to update recipe cache."
        return 3
    }
    install_packages "$@" || {
        echo "Failed to install packages."
        return 4
    }
}
