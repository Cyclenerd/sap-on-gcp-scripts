#!/usr/bin/env bash

# Delete all Compute Engine boot disk snapshots from specific instance

################################################################################
# INCLUDE FUNCTIONS
################################################################################

MY_INCLUDE='../inc/include.sh'
# ignore SC1090
# shellcheck source=/dev/null
if ! source "$MY_INCLUDE"; then
	ME=$(basename "$0")
	BASE_PATH=$(dirname "$0")
	echo;echo "× Can not read required include file '$MY_INCLUDE'";echo
	echo      "  Please start the script directly in the directory:"
	echo      "    cd $BASE_PATH && bash $ME";echo
	exit 9
fi

################################################################################
# MAIN
################################################################################

# Get last Compute Engine boot disk snapshot from specific instance
# In: MY_GCP_GCE_NAME
delete_all_snapshots_vm

# Check MY_WARNING and exit with echo_success or echo_failure
# In: MY_WARNING
check_warning_and_exit "All snapshots successfully deleted"
