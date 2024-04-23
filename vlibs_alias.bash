
function vlibs(){
    local vlibs_main
	local CACHE_DIR="$HOME/.cache/vlibs"
	if [ ! -d "$CACHE_DIR" ]; then
		mkdir -p "$CACHE_DIR"
	fi
	if [ ! -f "$CACHE_DIR/main.bash" ]; then
		vlibs_main=$(wget -qO- https://raw.githubusercontent.com/Vladastos/vlibs/main/main.bash)
		echo "$vlibs_main" > "$CACHE_DIR/main.bash"
	else
		vlibs_main=$(cat "$CACHE_DIR/main.bash")
	fi
	source <(echo "$vlibs_main")
	local library_name="$1"
	shift
	execute_vlibs "$library_name" "$@"
}
complete -W "$(vlibs -l)" vlibs