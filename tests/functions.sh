#!/bin/sh

### Tone testing functions ###


# Copy testing root into tone directory
# @ROOT_PATH --- full path to testing root directory
tone_copy_root () {
    ROOT_PATH="$1"
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

# Initialize tone
tone_init () {
    echo -n "Initializing tone..."
    $TONE init
    if [ $? != 0 ]; then
        echo "FAIL"
        return 1
    else
        echo "OK"
    fi
}

# Check files existance
# @FILE_NAME --- files path relative to tone direcotry
tone_check_file () {
    local FILE_NAME="$1"
    echo -n "Checking if file '${FILE_NAME}' exists..."
    if [ -f "${FILE_NAME}" ]; then
        echo "OK"
    else
        echo "FAIL"
        return 1
    fi
}

# Check directory existance
# @DIR_NAME --- files path relative to tone direcotry
tone_check_dir () {
    local DIR_NAME="$1"
    echo -n "Checking if directory '${DIR_NAME}' exists..."
    if [ -d "${DIR_NAME}" ]; then
        echo "OK"
    else
        echo "FAIL"
        return 1
    fi
}

