export RECIPE_DEPENDENCIES=(
    "git"
    "curl"
    "file"
    )
export PACMAN_DEPENDENCIES=(
    "base-devel"
    "procps-ng"
)
export APT_DEPENDENCIES=(
    "build-essential"
    "procps"
)



common_recipe(){
    echo "Hello World!"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    #TODO add support for zsh
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
}