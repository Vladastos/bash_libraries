#!/bin/bash
detect_package_manager() {
    if [ -x "$(command -v apt-get)" ]; then
        PACKAGE_MANAGER="apt-get"
    elif [ -x "$(command -v apt)" ]; then
        PACKAGE_MANAGER="apt"
    elif [ -x "$(command -v pacman)" ]; then
        PACKAGE_MANAGER="pacman"
    else
        PACKAGE_MANAGER="unknown"
    fi
}

construct_install_command() {
    if [ "$PACKAGE_MANAGER" == "brew" ]; then
        INSTALL_COMMAND="brew install"
    elif [ "$PACKAGE_MANAGER" == "apt-get" ]; then
        INSTALL_COMMAND="sudo apt-get install"
        if [ "$yes_flag" == true ]; then
            INSTALL_COMMAND="$INSTALL_COMMAND -y"
        fi
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
            check_recipe "$package" || return
            echo "Installing $package..."
            if [ "$package" == "brew" ]; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bash_profile
		        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            elif [ "$package" == "nvim" ]; then
                install_packages "brew"
                brew install neovim
            elif [ "$package" == "startEnv" ]; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Vladastos/startEnv/main/setup.bash)"
            else
                bash -c "$INSTALL_COMMAND $package"

            fi
            echo "$package has been installed."
        else
            echo "$package is already installed."
        fi
    done }

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
        echo "Recipe not found for $package"
    else
        use_recipe "$package"
    fi
}

use_recipe() {
    local package="$1"
    local RECIPE_URL="https://raw.githubusercontent.com/Vladastos/vlibs/main/lib/cook/recipes/${RECIPE_LIST[$package]}.recipe.bash"

    source <(curl -fsSL "$RECIPE_URL") || return
    echo "Using recipe for $package..."

    echo "Getting ingredients for $package..."
    install_packages "${RECIPE_DEPENDENCIES[@]}" || return

    echo "Following recipe for $package..."
    common_recipe
    if [ "$PACKAGE_MANAGER" == "pacman" ]; then
        pacman_recipe || return
    elif [ "$PACKAGE_MANAGER" == "apt" ]; then
        apt_recipe || return
    elif [ "$PACKAGE_MANAGER" == "apt-get" ]; then
        apt_recipe || return
    fi

    echo "Recipe for $package has been installed."
}

cook() {
    local COOK_VERSION="1.0.6b"
    local PACKAGE_MANAGER
    local OPERATING_SYSTEM
    local CACHE_DIR="$HOME"/.cache/vlibs
    local RECIPE_LIST_FILE="$CACHE_DIR"/cook/recipe_list.bash
    local RECIPE_LIST_URL="https://raw.githubusercontent.com/Vladastos/vlibs/main/lib/cook/recipe_list.bash"

    local yes_flag=true

    parse_args "$@" || return 0
    detect_package_manager
    construct_install_command || return
    detect_operating_system
    update_recipe_cache
    install_packages "$@"
}

