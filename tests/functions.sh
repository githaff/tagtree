#!/bin/sh

### Trut testing functions ###


# Copy testing root into trut directory
# @ROOT_PATH --- full path to testing root directory
trut_copy_root () {
    ROOT_PATH="${1}"
    echo -n "Copying testing root from '${ROOT_PATH}'..."
    if [ -d "${ROOT_PATH}" ]; then
        cd "${ROOT_PATH}"
        tar cf - . | (cd "${TEST_DIR}"; tar xf -) || return 1
        cd "${OLDPWD}"
        echo "OK"
    else
        echo "FAIL"
        return 1
    fi
}

# Initialize trut
trut_init () {
    echo -n "Initializing trut..."
    $TRUT init
    echo "OK"
}

# Check files existance
# @FILE_NAME --- files path relative to trut direcotry
trut_check_file () {
    local FILE_NAME="${1}"
    echo -n "Checking if file '${FILE_NAME}' exists..."
    if [ -d "${FILE_NAME}" ]; then
        echo "OK"
    else
        echo "FAIL"
        return 1
    fi
}

# Check directory existance
# @DIR_NAME --- files path relative to trut direcotry
trut_check_dir () {
    local DIR_NAME="${1}"
    echo -n "Checking if directory '${DIR_NAME}' exists..."
    if [ -d "${DIR_NAME}" ]; then
        echo "OK"
    else
        echo "FAIL"
        return 1
    fi
}

