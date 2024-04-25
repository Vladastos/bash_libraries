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

install_packages() { local packages=("$@")
    for package in "${packages[@]}"; do
    echo "Checking if $package is installed..."
        if ! command -v "$package" &> /dev/null; then
            echo "Installing $package..."
            if [ "$package" == "brew" ]; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            elif [ "$package" == "nvim" ]; then
                install_dependencies "brew"
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
    done
}

parse_args() {
    local args=("$@")
    for arg in "${args[@]}"; do
        if [ "$arg" == "-h" ] || [ "$arg" == "--help" ]; then
            echo "Usage: install [options] [package1 package2 ...]"
            echo "Options:"
            echo "  -h, --help  Show this help message"
            echo "  -y, --yes   Assume yes for all prompts"
            return 1
        fi
        if [ "$arg" == "-v" ] || [ "$arg" == "--version" ]; then
            echo "install version: $INSTALL_VERSION"
            return 1
        fi
        if [ "$arg" == "-y" ] || [ "$arg" == "--yes" ]; then
            yes_flag=true
        fi
    done
}

install() {
    local INSTALL_VERSION="1.0.2"
    local yes_flag=false
    parse_args "$@"
    if [ "$?" == 1 ]; then
        return
    fi
    detect_package_manager
    construct_install_command
    install_packages "$@"
}

