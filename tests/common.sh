#!/bin/sh

UTIL_NAME=$(basename $0)

usage () {
cat <<EOF
Usage: ${UTIL_NAME} OPTIONS
Test suite '${TEST_NAME}' scenario.

Options
  -h, --help     show help
  -k, --keep     keep temporary directories of failed tests.
                 Directory name will be printed into output
EOF
}

### Test environment
CHECK_FAIL_COUNTER="0"
RETCODE="0"

### Test fail retcodes
TEST_FAIL_INIT="1"
TEST_FAIL_CHECK="2"


############################### Parse arguments ###############################

test_parse_args () {
    local TEMP=$(getopt -o hk -l help,keep -n "${UTIL_NAME}" -- "$@")
    if [ $? != 0 ] ; then echo "Try '${UTIL_NAME} --help' for more information." >&2 ; exit 1 ; fi
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


############################### Error handling ###############################

# Non-critical error during some king of check
err () {
    RETCODE="${TEST_FAIL_CHECK}"
    CHECK_FAIL_COUNTER=$((CHECK_FAIL_COUNTER + 1))
}
# Critical error during test initialization
err_init () {
    RETCODE="${TEST_FAIL_INIT}"

    test_finalize
}


############################### Test control ###############################

test_init () {
    if [ -z "${TEST_NAME}" ]; then
        TEST_NAME="$(basename ${UTIL_NAME} .sh)"
    fi

    test_parse_args $@

    TEST_DIR="$(init_tmpdir)"
    cd "${TEST_DIR}"
}

test_finalize () {
    if [ ${RETCODE} == 0 ]; then
        echo "Test success"
        deinit_tmpdir
    else
        if [ ${RETCODE} == 255 ]; then
            echo "Test initialization fail. Aborting..."
        else
            echo "${CHECK_FAIL_COUNTER} checks was failed"
        fi

        if [ -n "${OPT_KEEP}" ]; then
            echo "Test environment is available at ${TEST_DIR}"
        else
            deinit_tmpdir
        fi
    fi

    exit ${RETCODE}
}


############################### MISC ###############################

init_tmpdir () {
    mktemp -d "/tmp/tone-tests.XXXXXXXXXX"
}

deinit_tmpdir () {
    rm -rf "${TEST_DIR}"
}
