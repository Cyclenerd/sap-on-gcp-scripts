#!/usr/bin/env bash

# Reset and return a password for a Windows machine instance

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

# Reset and return a password for a Windows machine instance
echo_title "Reset and return a password for Windows machine instance '$MY_GCP_GCE_NAME'"
if ! gcloud compute reset-windows-password "$MY_GCP_GCE_NAME" \
	--zone="$MY_GCP_ZONE" \
	--project="$MY_GCP_PROJECT"; then
	echo_warning "Could not create VM instance"
	export MY_WARNING=1
fi

# Check MY_WARNING and exit with echo_success or echo_failure
# In: MY_WARNING
check_warning_and_exit "Compute Engine virtual machine instance set up successfully"
