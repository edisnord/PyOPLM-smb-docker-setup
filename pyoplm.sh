#!/usr/bin/env bash

function workdir_to_compose {
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    cd $DIR
}

function crash {
    echo $1 1>&2
    exit $2
}

if [ "$1" = "add" ]; then
    ARGS=()
    SRC_FILE=""
    shift

    for var in "$@"; do
        if [ "${var:0:1}" == "-" ]; then
            ARGS+=$var
        elif [ "${var:0:1}" == "/" ]; then
            if [ ! -f "$var" ]; then
                crash "Input file $var does not exist" 2
            fi
            if [ -z "$SRC_FILE" ]; then
                SRC_FILE=$var
            else
                crash "Why have you supplied two input files? File 1: '${SRC_FILE}', File 2: '${var}'"
            fi
        else
            TMP=$(realpath $var)
            if [ ! -f "$TMP" ]; then
                crash "Input file $var does not exist" 2
            fi
        if [ -z "$SRC_FILE" ]; then
                SRC_FILE=$var
            else
                crash "Why have you supplied two input files? File 1: '${SRC_FILE}', File 2: '${var}'"
            fi
        fi
    done

    workdir_to_compose
    if [ -z "$SRC_FILE" ]; then
        docker compose run pyoplm add "${ARGS[@]}"
    else
        FILENAME=$(basename "$SRC_FILE")
        docker compose run -v "$SRC_FILE:/$FILENAME" pyoplm add "${ARGS[@]}" "/$FILENAME"
    fi
else
    workdir_to_compose
    docker compose run pyoplm $@
fi
