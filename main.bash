
main(){
    local lib_name="$1"
    local lib_path="lib/${lib_name}.bash"
    shift
    if [ ! -f "$lib_path" ]; then
        echo "Library not found: $lib_path"
        exit 1
    fi
    source "$lib_path" "$@"
}
