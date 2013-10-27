#!/bin/sh


### Test environment
FAIL_CHECK_COUNTER="0"

### Return code
TEST_RETCODE="0"

### Test fail retcodes
TEST_FAIL_INIT="1"
TEST_FAIL_CHECK="2"


### Corresponding err functions
err () {
    TEST_RETCODE="${TEST_FAIL_CHECK}"
    FAIL_CHECK_COUNTER=$((FAIL_CHECK_COUNTER + 1))
}

err_init () {
    TEST_RETCODE="${TEST_FAIL_INIT}"
    echo "Test wasn't initialized. Abort"

    exit ${TEST_RETCODE}
}


### Test control functions
test_init () {
    cd "${TEST_DIR}"
}

test_finalize () {
    echo "${FAIL_CHECK_COUNTER} checks was failed"
    exit ${TEST_RETCODE}
}
