#!/usr/bin/env bash

# Create a second Virtual Private Cloud (VPC) network in other region

################################################################################
# DEFAULTS
# Please do not modify anything here.
# Variables are overwritten by the 'config' file.
################################################################################

# Project
export MY_GCP_REGION="europe-west4"
export MY_GCP_ZONE="$MY_GCP_REGION-c"

# Network
export MY_GCP_SUBNET="subnet-$MY_GCP_REGION"
export MY_GCP_SUBNET_RANGE="192.168.204.0/24"

# Router
export MY_GCP_ROUTER="router-$MY_GCP_REGION"
export MY_GCP_NAT="nat-$MY_GCP_REGION"


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

echo_title "Create network in region '$MY_GCP_REGION'"

# Define a subnet with IP range for the network
# In: MY_GCP_SUBNET, MY_GCP_SUBNET_RANGE, MY_GCP_NETWORK, MY_GCP_REGION
create_subnet

# Create a Compute Engine router
# In: MY_GCP_ROUTER, MY_GCP_NETWORK, MY_GCP_REGION
create_router

# Add a NAT to a Compute Engine router
# In: MY_GCP_NAT, MY_GCP_ROUTER, MY_GCP_REGION
create_nat

# Check MY_WARNING and exit with echo_success or echo_failure
# In: MY_WARNING
check_warning_and_exit "Network set up successfully"
