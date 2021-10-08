#!/usr/bin/env bash

# Create a service account for the SAP Cloud Appliance Library

################################################################################
# DEFAULTS
# Please do not modify anything here.
# Variables are overwritten by the 'config' file.
################################################################################

export MY_GCP_SA_NAME="sa-sap-cal"
export MY_GCP_SA_DISPLAY_NAME='SAP Cloud Appliance Library'
export MY_GCP_SA_DESCRIPTION='Service account for SAP Cloud Appliance Library'
# Compute Instance Admin (v1)
# Compute Network Admin
# Compute Security Admin
export MY_GCP_SA_ROLES=(
	'roles/compute.instanceAdmin.v1'
	'roles/compute.networkAdmin'
	'roles/compute.securityAdmin'
)

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

# In: MY_GCP_SA_NAME, MY_GCP_SA_DISPLAY_NAME, MY_GCP_SA_DESCRIPTION
create_service_account
# Out: MY_GCP_SA_ID
get_service_account_identifier

# Add IAM roles (policy binding) to service account
# In: MY_GCP_SA_ID, MY_GCP_SA_ROLES
add_projects_policy_binding

# Delete all user-managed keys from service account
delete_all_service_account_keys

# Create new private key for service account
# In: MY_GCP_SA_ID, MY_GCP_SA_FILE
create_service_account_key

# Print private key JSON file
# In: MY_GCP_SA_FILE
print_service_account_key

# Check MY_WARNING and exit with echo_success or echo_failure
# In: MY_WARNING
check_warning_and_exit "Service account set up successfully"
