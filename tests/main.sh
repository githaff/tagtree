#!/bin/sh

### TESTS SUITE RULES
# Each test must:
# - be presented as XX-*.sh file (where XX is number);
# - if needed use 'root' directory as default root for tagging
# - if special testing root is needed use XX-* (same as script name)
# - do not rely on some state, reinitialize tone for each test;

UTIL_NAME=$(basename $0)

usage () {
cat <<EOF
Usage: ${UTIL_NAME} OPTIONS
Test suite for tone utility.

Options
  -h, --help     show help
  -k, --keep     keep temporary directories of failed tests.
                 Directory name will be printed into logs
  -b, --brief    Do not print logs for failed tests
  -m, --manual   Manual testing mode. Will create temporay dir for
                 performing tests
EOF
}


## Manage temporary directory for testing
clean_prev_tmp () {
    rm -rf "/tmp/tone-tests."*
}

## Manually create special testing directory with default root in it
init_manual () {
    local TEST_DIR=$(mktemp -d "/tmp/tone-tests-manual.XXXXXXXXXX")
    cd "${SCRIPT_DIR}/root"
    tar cf - . | (cd "${TEST_DIR}"; tar xf -)
    cd "${OLDPWD}"
    echo "${TEST_DIR}"
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

# Indent input test by 2 spaces
indent_test () {
    sed 's/^/  /'
}



SCRIPT_DIR="$(readlink -f $(dirname ${0}))"


############################### Parse arguments ###############################

parse_args () {
    local TEMP=$(getopt -o hkbm -l help,keep,brief,manual -n "${UTIL_NAME}" -- "$@")
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
            -b|--brief)
                OPT_PRINT_LOG_OFF=y
                shift
                ;;
            -m|--manual)
                OPT_MANUAL=y
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


parse_args $@
clean_prev_tmp

if [ -n "${OPT_MANUAL}" ]; then
    TEST_DIR="$(init_manual)"
    echo "${TEST_DIR}"
    exit
fi

mkdir -p "${SCRIPT_DIR}/log"

for test in $(get_tests); do
    test_name="$(get_name ${test})"
    LOGFILE="${SCRIPT_DIR}/log/$(basename ${test} .sh).log"
    echo -n "Running ${test_name}..."

    sh "${test}" > "${LOGFILE}" 2>&1 
    RETCODE=$?
    if [ ${RETCODE} != 0 ]; then
        if [ -z "${OPT_PRINT_LOG_OFF}" ]; then
            echo
            cat "${LOGFILE}" | indent_test
            echo -n "Running ${test_name}..."
        fi
        test_fail
    else
        test_done
    fi
done
