#!/usr/bin/env bash

# Create service account and Compute Engine virtual machine instance

################################################################################
# DEFAULTS
# Please do not modify anything here.
# Variables are overwritten by the 'config' file.
################################################################################

export MY_GCP_GCE_NAME="sles"
export MY_GCP_GCE_TYPE="g1-small"
export MY_GCP_GCE_DISK_BOOT_SIZE="32GB"
export MY_GCP_GCE_IMAGE_FAMILY="sles-15"
export MY_GCP_GCE_IMAGE_PROJECT="suse-cloud"

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

# Create service account for virtual machine
# In: MY_GCP_SA_NAME, MY_GCP_SA_DISPLAY_NAME, MY_GCP_SA_DESCRIPTION
create_service_account
# Get service account identifier or exit_with_failure
# In: MY_GCP_SA_NAME
# Out: MY_GCP_SA_ID
get_service_account_identifier

# Add IAM roles (policy binding) to service account
# In: MY_GCP_SA_ID, MY_GCP_SA_ROLES
add_projects_policy_binding

# Add service account read access to storage bucket
# In: MY_GCP_SA_ID, MY_GCP_STORAGE
add_read_access_storage

# Create Compute Engine virtual machine instance
# In: 
#    MY_GCP_GCE_NAME
#    MY_GCP_ZONE
#    MY_GCP_GCE_TYPE
#    MY_GCP_SUBNET
#    MY_GCP_SA_ID
#    MY_GCP_GCE_IMAGE_PROJECT
#    MY_GCP_GCE_IMAGE_FAMILY
#    MY_GCP_GCE_DISK_BOOT_NAME
#    MY_GCP_GCE_DISK_BOOT_SIZE
#    MY_GCP_GCE_STARTUP_SCRIPT_URL
create_vm

# Check MY_WARNING and exit with echo_success or echo_failure
# In: MY_WARNING
check_warning_and_exit "Compute Engine virtual machine instance set up successfully"
