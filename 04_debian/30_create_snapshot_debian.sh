#!/usr/bin/env bash

# Create snapshot of Compute Engine persistent boot disk

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

# Create snapshot of Compute Engine persistent boot disk
# In:
#    MY_GCP_GCE_DISK_BOOT_NAME
#    MY_GCP_REGION
#    MY_GCP_ZONE
#    MY_GCP_PROJECT
create_snapshot

# Check MY_WARNING and exit with echo_success or echo_failure
# In: MY_WARNING
check_warning_and_exit "Compute Engine disk snapshot created successfully"
