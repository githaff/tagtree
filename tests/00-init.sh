#!/bin/sh

######################## Test initialization ########################

TEST_NAME="Initialization test"

TRUT="${1}"
TEST_DIR="${2}"
SCRIPT_DIR="$(readlink -f $(dirname ${0}))"

source "${SCRIPT_DIR}/functions.sh"
cd "${TEST_DIR}"


############################# Test body #############################

# Initialize empty tagtree
trut_init || exit 1

# Check all '.trut' files
trut_check_dir ".trut"         || exit 2
trut_check_dir ".trut/storage" || exit 2
trut_check_file ".trut/meta"   || exit 2
trut_check_file ".trut/config" || exit 2
