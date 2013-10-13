#!/bin/sh

### Trut testing functions ###


# Initialize trut
trut_init () {
    echo -n "Initializing trut..."
    $TRUT init
    echo "OK"
}

# Check files existance
# @FILE_NAME --- files path relative to trut direcotry
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

# Check directory existance
# @DIR_NAME --- files path relative to trut direcotry
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

