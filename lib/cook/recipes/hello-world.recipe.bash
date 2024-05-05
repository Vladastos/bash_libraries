#!/bin/bash
common_recipe(){
    echo "Hello World!"
}
apt_recipe(){
    echo "Apt"
}
pacman_recipe(){
    echo "Pacman"
}

main(){

    common_recipe
    if [ "$1" == "Pacman" ]; then
        apt_recipe
    elif [ "$1" == "Apt" ]; then
        apt_recipe
    fi

}

