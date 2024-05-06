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
        return "${ERRORS["package_manager_error"]}"
    fi
}

construct_install_command() {
    if [ "$PACKAGE_MANAGER" == "apt" ]; then
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
       return "${ERRORS["package_manager_error"]}"
    fi
}

install_packages() {
    local packages=("$@")
    for package in "${packages[@]}"; do
        echo "Checking if $package is installed..."
        if ! command -v "$package" &> /dev/null; then
            # Check if there is a recipe available with the given name.
            # If so, use it, otherwise install the package using the package manager
            echo "searching recipe for $package..."
            search_recipe "$package" || install_package "$package" 
        else
            echo "$package is already installed."
        fi
    done 
}

install_package() {
    local package="$1"
    echo "Installing $package..."
    bash -c "$INSTALL_COMMAND $package" || return "${ERRORS["install_packages_error"]}"
    echo "Successfully installed $package."
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
            echo "Using version: $INSTALL_VERSION"
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
    if [ ! -f "$RECIPE_LIST_FILE" ]; then
        echo "Updating recipe cache..."
        wget -qO "$RECIPE_LIST_FILE" "$RECIPE_LIST_URL"
    fi
}

search_recipe() {
    local package="$1"
    source "$RECIPE_LIST_FILE"
    if [ -z "${RECIPE_LIST[$package]}" ]; then
        return 1
    fi
    export -f use_recipe
    # Export the function so that it can be used in the recipe, then execute it
    bash -c "$(curl -fsSL "$REMOTE_INSTALL_URL/recipes/${RECIPE_LIST[$package]}.recipe.bash") ${RECIPE_LIST[$package]}"
}

use_recipe() {
    local recipe="$1"
    echo "$recipe is cooking..."
}

install() {
    declare -A ERRORS=(
        [package_manager_error]='2'
        ["update_recipe_cache_error"]='3'
        ["install_packages_error"]='4'
    )

    trap 'exit_handler' EXIT

    local INSTALL_VERSION="1.0.7c2"
    local PACKAGE_MANAGER
    local CACHE_DIR="$HOME"/.cache/vlibs
    local REMOTE_INSTALL_URL="https://raw.githubusercontent.com/Vladastos/vlibs/main/lib/install"
    local RECIPE_LIST_FILE="$CACHE_DIR"/install/recipe_list.bash
    local RECIPE_LIST_URL="https://raw.githubusercontent.com/Vladastos/vlibs/main/lib/install/recipe_list.bash"

    local yes_flag=true

    parse_args "$@" || return 0
    detect_package_manager || return "${ERRORS["package_manager_error"]}"
    construct_install_command || return "${ERRORS["install_packages_error"]}"
    update_recipe_cache || return "${ERRORS["update_recipe_cache_error"]}"
    install_packages "$@" || return "${ERRORS["install_packages_error"]}"
}
