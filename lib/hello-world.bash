hello-world(){
    echo "Hello World"
    if [ "$#" -gt 0 ]; then
        echo "Parameters: $@"
    fi
}
