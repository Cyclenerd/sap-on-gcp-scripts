#!/usr/bin/env bash

# Delete service account for the SAP Cloud Appliance Library

################################################################################
# INCLUDE FUNCTIONS
################################################################################

MY_INCLUDE='./inc/include.sh'
# ignore SC1090
# shellcheck source=/dev/null
if ! source "$MY_INCLUDE" > /dev/null 2>&1; then
	ME=$(basename "$0")
	BASE_PATH=$(dirname "$0")
	echo;echo "× Can not read required include file '$MY_INCLUDE'";echo
	echo      "  Please start the script directly in the directory:"
	echo      "    cd $BASE_PATH && bash $ME";echo
	exit 9
fi

################################################################################
# DEFAULTS
# Please do not modify anything here.
# Variables are overwritten by the 'config' file.
################################################################################

export MY_GCP_SA_NAME="sa-sap-cal"
export MY_GCP_SA_FILE="private_key_""$MY_GCP_SA_NAME""_JSON.json"

################################################################################
# MAIN
################################################################################

# Reset warnings
export MY_WARNING=0

# Check required programs
check_command gcloud
# Load config file
load_config
# Check active account
check_auth

# # Get service account identifier or exit_with_failure
# In: MY_GCP_SA_NAME
# Out: MY_GCP_SA_ID
get_service_account_identifier

# Delete service account and key
# In: MY_GCP_SA_ID
delete_service_account
delete_service_account_key

# Check MY_WARNING and exit with echo_success or echo_failure
# In: MY_WARNING
check_warning_and_exit "Service account deleted successfully"
