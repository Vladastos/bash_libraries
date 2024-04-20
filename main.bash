
vladastos_libs(){
    local lib_name="$1"
    echo "Using version 0.0.2"
    echo "Loading library: $lib_name"
    shift
    local lib_path=https://raw.githubusercontent.com/Vladastos/bash_libraries/main/lib/$lib_name.bash
    if ! wget -q --spider "$lib_path" &>/dev/null; then
        echo "Library $lib_name not found"
            return 1
    fi
    local lib=$(wget -qO- "$lib_path")
    source <(echo "$lib")
    "$lib_name" "$@"
}

