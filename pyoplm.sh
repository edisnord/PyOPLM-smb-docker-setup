#!/usr/bin/env bash

MOUNTS=()

function add_mount {
    MOUNTS+=("-v")
    MOUNTS+=("${1}:/$2")
}

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
            ARGS+=($var)
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
        add_mount "$SRC_FILE" "$FILENAME"

        echo $FILENAME
        if [[ $FILENAME =~ \.(c|C)(u|U)(e|E)$ ]]; then
            while read line; do
                if [[ "$line" =~ \"(.*\.bin)\" ]]; then
                    add_mount "$(dirname "$SRC_FILE")/${BASH_REMATCH[1]}" "${BASH_REMATCH[1]}"
                fi
            done < "$SRC_FILE"
        fi

        docker compose run "${MOUNTS[@]}" pyoplm add "${ARGS[@]}" "/$FILENAME"
    fi
elif [ $1 = "update" ]; then
    echo "Rebuilding PyOPLM image..."
    docker compose build --no-cache pyoplm
    exit 0
else
    workdir_to_compose
    docker compose run pyoplm $@
fi

docker rm $(docker stop $(docker container ls -a --filter="name=pyoplm-run" --format="{{.ID}}")) >/dev/null 2>&1
