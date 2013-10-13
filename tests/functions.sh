#!/bin/sh

### Trut testing functions ###

trut_init () {
    echo -n "Initializing trut..."
    $TRUT init
    echo "OK"
}

trut_check_file () {
    local FILE_NAME=${1}
    echo "Checking if file '${FILE_NAME}' exists..."
    if [ -d "${FILE_NAME}" ]; then
        echo "OK"
    else
        echo "FAIL"
        exit 1
    fi
}

trut_check_dir () {
    local DIR_NAME=${1}
    echo -n "Checking if directory '${DIR_NAME}' exists..."
    if [ -d "${DIR_NAME}" ]; then
        echo "OK"
    else
        echo "FAIL"
        exit 1
    fi
}

