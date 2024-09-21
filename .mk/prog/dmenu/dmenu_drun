#!/usr/bin/env bash

# parses known locations for .desktop files
# written by Nathaniel Maia, June 2018

# associative array to store paths as basename values
declare -A PATHS

# check we have required software
if ! hash awk find grep dmenu &>/dev/null; then
    echo -e "ERROR: This script requires: awk find grep dmenu" && exit 1
fi

main() {
    # base file name storage
    local names=""
    while read -r f; do
        n="$(basename "$f" | awk -F'.' '{print $1}')"
        names="$names
$n"
        PATHS["$n"]="$f"
    done <<< "$(find -L /usr/share/applications/ -type f -name '*.desktop' | sort -r)"

    local ans="$(dmenu "$@" <<< "$names")"
    [[ $? != 1 && -n $ans ]] && run "$ans" || return 1
}

run() {
    local cmd
    cmd="$(grep '^Exec' "${PATHS["$1"]}")"
    cmd="${cmd/Exec=/}"
    cmd="${cmd/ %*/}"
    echo -e "$cmd"
    { [[ $cmd ]] && "$cmd" || return 1; }
    if [[ $? != 0 ]]; then
        echo "ERROR: Something went wrong when trying to run: $cmd"
        return 1
    fi
    return 0
}

main "$@" &

exit 0
