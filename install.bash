
mkdir -p ~/.config/vlibs
wget -qO ~/.config/vlibs/vlibs_alias.bash https://raw.githubusercontent.com/Vladastos/vlibs/main/vlibs_alias.bash
echo "source ~/.config/vlibs/vlibs_alias.bash" >> ~/.bashrc
source ~/.bashrc
mkdir -p ~/.cache/vlibs
echo $(vlibs --list) > ~/.cache/vlibs/library_list
