#!/usr/bin/env bash

# Show details and generate a valid SAP master password

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

# Project details
echo_title "Instance Details"
echo "Region  : $MY_GCP_REGION"
echo "Zone    : $MY_GCP_ZONE"
echo "Network : $MY_GCP_NETWORK"
echo "Subnet  : $MY_GCP_SUBNET"

# Generate a valid SAP master password
generate_password
echo_key "SAP master password: $MY_PASSWORD"