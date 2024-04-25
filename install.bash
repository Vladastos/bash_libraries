#!/bin/bash
install_vlibs(){
    mkdir -p ~/.config/vlibs
    wget -qO ~/.config/vlibs/vlibs_alias.bash https://raw.githubusercontent.com/Vladastos/vlibs/main/vlibs_alias.bash
    echo "source $HOME/.config/vlibs/vlibs_alias.bash" >> ~/.bashrc
    mkdir -p ~/.cache/vlibs
    touch ~/.cache/vlibs/library_list
    echo "hello-world install" > ~/.cache/vlibs/library_list
    echo "Installed vlibs"
}
install_vlibs
