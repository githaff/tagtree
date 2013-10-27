#!/bin/sh

######################## Test initialization ########################

TEST_NAME="Initialization test"

TRUT="${1}"
TEST_DIR="${2}"
SCRIPT_DIR="$(readlink -f $(dirname ${0}))"

source "${SCRIPT_DIR}/common.sh"
source "${SCRIPT_DIR}/functions.sh"

test_init


############################# Test body #############################

# Initialize empty tagtree
trut_init || err_init

#err_init
# Check all '.trut' files
trut_check_dir ".trut"         || err
trut_check_dir ".trut/storage" || err
trut_check_file ".trut/meta"   || err
trut_check_file ".trut/config" || err


############################# Test exit #############################

test_finalize
