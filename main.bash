#!/bin/bash
check_if_in_cache_and_execute(){
    #TODO check if library is already in cache and load from there
    local CACHE_DIR="$HOME"/.cache/vlibs
    mkdir -p "$CACHE_DIR"
    local lib_name="$1"
    shift
    local lib_remote_path=https://raw.githubusercontent.com/Vladastos/vlibs/main/lib/$lib_name/$lib_name.bash
    local lib_path="$CACHE_DIR"/"$lib_name".bash
    if [ ! -f "$lib_path" ]; then
        #if not in cache download
        if ! wget -q --spider "$lib_remote_path" &>/dev/null; then
            echo "Library $lib_name not found"
            return 1
        fi
        echo "Caching library: $lib_name"
        touch "$lib_path"
        wget -qO "$lib_path" "$lib_remote_path"
    fi
    echo "Executing library: $lib_name"
    #shellcheck source=/dev/null
    source "$lib_path"
    "$lib_name" "$@"

}

get_library_list(){
    local library_list="hello-world install"
    echo "$library_list"
}

uninstall_vlibs(){
    rm -rf "$HOME"/.cache/vlibs
    rm -rf "$HOME"/.config/vlibs
    sed -i '/vlibs/d' ~/.bashrc
    source ~/.bashrc
    echo "Uninstalled vlibs"
}

parse_args(){
    for arg in "$@"; do
        if [ "$arg" == "-h" ] || [ "$arg" == "--help" ]; then
            echo "Usage: vlibs [options] <lib_name> [arguments]"
            echo "Options:"
            echo "  -h, --help          Show this help message"
            echo "  -v, --version       Show the version number"
            echo "  -l, --list          List all available libraries"
            echo "  --clear-cache       Clear the cache"
            echo "  --uninstall         Uninstall vlibs"
            return 1
        fi
        if [ "$arg" == "-v" ] || [ "$arg" == "--version" ]; then
            echo "Using version 0.0.10"
            return 1
        fi
        if [ "$arg" == "-l" ] || [ "$arg" == "--list" ]; then
            get_library_list
            return 1
        fi
        if [ "$arg" == "--clear-cache" ]; then
            rm -rf "$HOME"/.cache/vlibs
            return 1
        fi
        if [ "$arg" == "--uninstall" ]; then
            uninstall_vlibs
            return 1
        fi
    done
    return
}

execute_vlibs(){
    if [ "$#" -eq 0 ] || [ "$1" == ""  ]; then
        echo "Usage: vlibs <lib_name> [arguments]"
        return
    fi
    parse_args "$@"
    if [ "$?" -eq 1 ]; then
        return 
    fi
    check_if_in_cache_and_execute "$@"
}
