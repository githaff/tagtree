#!/bin/sh

######################## Test initialization ########################

TEST_NAME="Initialization test"

TRUT_EXEC="${1}"
TEST_DIR="${2}"
SCRIPT_DIR="$(pwd)"

source "${SCRIPT_DIR}/functions.sh"
cd "${TEST_DIR}"


############################# Test body #############################

${TRUT_EXEC}

exit 1

