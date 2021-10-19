#!/usr/bin/env bash

# Create Compute Engine persistent boot disk from last snapshot and
# create virtual machine instance with created disk

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
# Out: MY_GCE_SNAPSHOT_NAME
get_last_snapshot_vm

# Use snapshot to create a new boot disk
# In: MY_GCE_SNAPSHOT_NAME, MY_GCP_GCE_DISK_BOOT_NAME, MY_GCP_GCE_DISK_BOOT_TYPE
create_disk_from_snapshot

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

# Create GCE virtual machine instance with already created disk
# In:
#    MY_GCP_GCE_NAME
#    MY_GCP_ZONE
#    MY_GCP_GCE_TYPE
#    MY_GCP_SUBNET
#    MY_GCP_SA_ID
#    MY_GCP_GCE_DISK_BOOT_NAME
create_disk_vm

# Check MY_WARNING and exit with echo_success or echo_failure
# In: MY_WARNING
check_warning_and_exit "Compute Engine virtual machine instance set up successfully"
