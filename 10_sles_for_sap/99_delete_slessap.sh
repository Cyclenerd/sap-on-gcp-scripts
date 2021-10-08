#!/usr/bin/env bash

# Delete Compute Engine virtual machine instance and service account

################################################################################
# DEFAULTS
# Please do not modify anything here.
# Variables are overwritten by the 'config' file.
################################################################################

export MY_GCP_GCE_NAME="slessap"

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

# Get service account identifier or exit_with_failure
# In: MY_GCP_SA_NAME
# Out: MY_GCP_SA_ID
get_service_account_identifier

# Delete Compute Engine virtual machine instance
# In: MY_GCP_GCE_NAME, MY_GCP_ZONE
delete_vm

# Remove service account read access from storage bucket
# In: MY_GCP_SA_ID, MY_GCP_STORAGE
remove_read_access_storage

# Delete service account
# In: MY_GCP_SA_ID
delete_service_account

# Check MY_WARNING and exit with echo_success or echo_failure
# In: MY_WARNING
check_warning_and_exit "Compute Engine virtual machine instance deleted successfully"
