#!/bin/bash
detect_package_manager() {
    if [ -x "$(command -v apt)" ]; then
        PACKAGE_MANAGER="apt"
    elif [ -x "$(command -v pacman)" ]; then
        PACKAGE_MANAGER="pacman"
    elif [ -x "$(command -v yum)" ]; then
        PACKAGE_MANAGER="yum"
    elif [ -x "$(command -v dnf)" ]; then
        PACKAGE_MANAGER="dnf"
    elif [ -x "$(command -v zypper)" ]; then
        PACKAGE_MANAGER="zypper"
    elif [ -x "$(command -v apk)" ]; then
        PACKAGE_MANAGER="apk"
    else
        PACKAGE_MANAGER="unknown"
    fi
}

construct_install_command() {
    if [ "$PACKAGE_MANAGER" == "brew" ]; then
        INSTALL_COMMAND="brew install"
    elif [ "$PACKAGE_MANAGER" == "apt" ]; then
        INSTALL_COMMAND="sudo apt install"
    elif [ "$PACKAGE_MANAGER" == "pacman" ]; then
        INSTALL_COMMAND="sudo pacman -S"
    elif [ "$PACKAGE_MANAGER" == "yum" ]; then
        INSTALL_COMMAND="sudo yum install"
    elif [ "$PACKAGE_MANAGER" == "dnf" ]; then
        INSTALL_COMMAND="sudo dnf install"
    elif [ "$PACKAGE_MANAGER" == "zypper" ]; then
        INSTALL_COMMAND="sudo zypper install"
    elif [ "$PACKAGE_MANAGER" == "apk" ]; then
        INSTALL_COMMAND="sudo apk add"
    else
        INSTALL_COMMAND="unknown"
        echo "Unknown package manager. Please install dependencies manually."
        exit 1
    fi
}
install_dependencies() {
    local dependencies=("$@")
    for dependency in "${dependencies[@]}"; do
    echo "Checking if $dependency is installed..."
        if ! command -v "$dependency" &> /dev/null; then
            echo "Installing $dependency..."
            if [ "$dependency" == "brew" ]; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            elif [ "$dependency" == "nvim" ]; then
                intall_dependencies "brew"
                brew install neovim
            else
                bash -c "$INSTALL_COMMAND $dependency"

            fi
            echo "$dependency has been installed."
        else
            echo "$dependency is already installed."
        fi
    done
}

install() {
    detect_package_manager
    construct_install_command
    install_dependencies "$@"
}

