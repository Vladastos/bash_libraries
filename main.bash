#!/bin/bash
check_if_in_cache_and_execute(){
    #TODO check if library is already in cache and load from there
    local CACHE_DIR="$HOME"/.cache/vlibs
    mkdir -p "$CACHE_DIR"
    local lib_name="$1"
    shift
    local lib_remote_path=https://raw.githubusercontent.com/Vladastos/bash_libraries/main/lib/$lib_name.bash
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
vladastos_libs(){
    if [ "$#" -lt 0 ]; then
        echo "Usage: vladastos_libs <lib_name>"
    fi
    echo "Using version 0.0.5"
    check_if_in_cache_and_execute "$@"
}

