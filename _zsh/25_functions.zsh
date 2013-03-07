# Reload function
function rfunc() {
    if [ $# -ne 1 ]; then
        echo "usage: $0 <function name>" 1>&2
        return 1
    fi

    unfunction $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$1 is not defined" 1>&2
        return 1
    fi
    autoload +X $1

    return 0
}
