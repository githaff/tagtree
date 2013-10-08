#!/bin/sh


## Manage temporary directory for testing
init_tmp () {
    TEST_DIR="$(mktemp -d \"tagtree-tests.XXXXXXXXXX\")"
}

deinit_tmp () {
    rm -rf "${TEST_DIR}"
}


## Get all tests
get_tests () {
    SCRIPT_DIR="$(pwd)"
    find "${SCRIPT_DIR}" -name "*-*.sh" -a -executable -a ! -name "main.sh" | sort
}

## Retrieve test name from script file
get_name () {
    local NAME=$(sed -n 's/.*TEST_NAME *= *"\(.*\)".*/\1/p' "${1}")
    if [ -n "${NAME}" ]; then
        echo "'${NAME}'"
    else
        echo "$(basename ${1})"
    fi
}

## Handle results
test_done () {
    echo -e "[\e[1;32mDONE\e[0m]"
}

test_fail () {
    echo -e "[\e[1;31mFAIL\e[0m]"
}



echo "Testing tagtree..."

init_tmp

TESTS=$(get_tests)

for test in $(get_tests); do
    test_name="$(get_name ${test})"
    echo -n "Performing ${test_name}..."

    sh "${test}" && test_done || test_fail
done


deinit_tmp
