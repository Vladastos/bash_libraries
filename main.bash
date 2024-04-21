#!/bin/bash
check_if_in_cache_and_execute(){
    #TODO check if library is already in cache and load from there
    local CACHE_DIR="$HOME"/.cache/vlibs
    mkdir -p "$CACHE_DIR"
    local lib_name="$1"
    shift
    local lib_remote_path=https://raw.githubusercontent.com/Vladastos/bash_libraries/main/lib/$lib_name/$lib_name.bash
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

parse_args(){
    for arg in "$@"; do
        if [ "$arg" == "-h" ] || [ "$arg" == "--help" ]; then
            echo "Usage: vladastos_libs <lib_name>"
            echo "Options:"
            echo "  -h, --help          Show this help message"
            echo "  -v, --version       Show the version number"
            echo "  --clear-cache       Clear the cache"
            return 1
        fi
        if [ "$arg" == "-v" ] || [ "$arg" == "--version" ]; then
            echo "Using version 0.0.8"
            return 1
        fi
        if [ "$arg" == "--clear-cache" ]; then
            rm -rf "$HOME"/.cache/vlibs
            return 1
        fi
    done
    return
}
vladastos_libs(){
    if [ "$#" -eq 0 ]; then
        echo "Usage: vladastos_libs <lib_name>"
    fi
    parse_args "$@"
    if [ "$?" -eq 1 ]; then
        return 
    fi
    check_if_in_cache_and_execute "$@"
}
