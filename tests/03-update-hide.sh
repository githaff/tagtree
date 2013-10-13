#!/bin/sh

######################## Test initialization ########################

TEST_NAME="Hide command test"

TRUT="${1}"
TEST_DIR="${2}"
SCRIPT_DIR="$(readlink -f $(dirname ${0}))"

source "${SCRIPT_DIR}/functions.sh"
cd "${TEST_DIR}"


############################# Test body #############################


