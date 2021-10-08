#!/usr/bin/env bash

# List project content

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

echo_title "List project '$MY_GCP_PROJECT'"
echo_web "https://console.cloud.google.com/home/activity?project=$MY_GCP_PROJECT"

# List all service accounts
list_service_accounts

# List all Compute Engine routers
list_routers

# List all Compute Engine subnets and networks
list_subnets

# List all non-dynamic Google Compute Engine routes
list_routes

# List all firewall rules
list_firewall_rules

# List all storage buckets
list_storage

# List all secret names
list_secrets

# List all Compute Engine virtual machine instances
list_vms
