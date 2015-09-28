#!/bin/sh

######################## Test initialization ########################

TEST_NAME="Initialization test"

SCRIPT_DIR="$(readlink -f $(dirname ${0}))"
TONE="${SCRIPT_DIR}/../bin/tone"

source "${SCRIPT_DIR}/common.sh"
source "${SCRIPT_DIR}/functions.sh"

test_init $@


############################# Test body #############################

# Initialize empty tagtree
tone_init || err_init

#err_init
# Check all '.tone' files
tone_check_dir ".tone"         || err
tone_check_dir ".tone/storage" || err
tone_check_file ".tone/meta"   || err
tone_check_file ".tone/config" || err


############################# Test exit #############################

test_finalize
