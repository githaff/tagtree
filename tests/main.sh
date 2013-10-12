#!/bin/sh

### TESTS USAGE
# Each test must:
# - be presented as XX-*.sh file (where XX is number);
# - if needed use 'root' directory as default root for tagging
# - if special testing root is needed use XX-* (same as script name)
# - do not rely on some state, reinitialize trut for each test;
# - take command line arguments according to usage:
#   TEST_NAME TRUT_EXEC TMP_DIR
#   , where
#     TRUT_EXEC --- path to trut binary executable
#     TMP_DIR   --- path to temporary directory where testing will be
#                   performed


## Manage temporary directory for testing
init_tmp () {
    mktemp -d \"trut-tests.XXXXXXXXXX\"
}

deinit_tmp () {
    rm -rf "${TEST_DIR}"
}


## Get all tests
get_tests () {
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


SCRIPT_DIR="$(pwd)"
TRUT_EXEC="${SCRIPT_DIR}/../bin/trut"

############################## Testing procedure ##############################

echo "Testing trut..."

TESTS=$(get_tests)

for test in $(get_tests); do
    test_name="$(get_name ${test})"
    echo -n "Performing ${test_name}..."

    TEST_DIR="$(init_tmp)"

    sh "${test}" "${TRUT_EXEC}" "${TEST_DIR}" && test_done || test_fail
done


deinit_tmp
