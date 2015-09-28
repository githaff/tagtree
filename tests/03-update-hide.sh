#!/bin/sh

######################## Test initialization ########################

TEST_NAME="Hide command test"

SCRIPT_DIR="$(readlink -f $(dirname ${0}))"
TONE="${SCRIPT_DIR}/../bin/tone"

source "${SCRIPT_DIR}/common.sh"
source "${SCRIPT_DIR}/functions.sh"

test_init $@


############################# Test body #############################


############################# Test exit #############################

test_finalize
