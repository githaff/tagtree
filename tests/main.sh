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

UTIL_NAME=$(basename $0)

usage () {
cat <<EOF
Usage: ${UTIL_NAME} OPTIONS
Test suite for trut utility.

Options
  -h, --help     show help
  -k, --keep     keep temporary directories of failed tests.
                 Directory name will be printed into logs
EOF
}


## Manage temporary directory for testing
init_tmp () {
    mktemp -d "/tmp/trut-tests.XXXXXXXXXX"
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


############################### Parse arguments ###############################

parse_arguments () {
    local TEMP=$(getopt -o hk -l help,keep -n "${UTIL_NAME}" -- "$@")
    if [ $? != 0 ] ; then echo "Try '${UTIL_NAME} --h' for more information." >&2 ; exit 1 ; fi
    eval set -- "$TEMP"
    while true ; do
        case "$1" in
	    -h|--help)
                usage
                exit 0
                ;;
            -k|--keep)
                OPT_KEEP=y
                shift
                ;;
	    --)
	        shift
                break
                ;;
        esac
    done
}

############################## Testing procedure ##############################

parse_arguments $@

echo "Testing trut..."

TESTS=$(get_tests)

for test in $(get_tests); do
    test_name="$(get_name ${test})"
    LOGFILE="$(basename ${test} .sh).log"
    echo -n "Performing ${test_name}..."

    TEST_DIR="$(init_tmp)"

    sh "${test}" "${TRUT_EXEC}" "${TEST_DIR}" > "${LOGFILE}" 2>&1 
    RETCODE=$?
    if [ ${RETCODE} != 0 ]; then
        echo "Test failed with code ${RETCODE}" >> "${LOGFILE}"
        if [ -n "${OPT_KEEP}" ]; then
            echo "Test environment accessible at ${TEST_DIR}" >> "${LOGFILE}"
        else
            deinit_tmp
        fi
        test_fail
    else
        echo "Test success" >> "${LOGFILE}"
        test_done
        deinit_tmp
    fi

done
