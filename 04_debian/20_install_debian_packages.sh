#!/usr/bin/env bash

# SSH into a Linux virtual machine instance and install packages

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

# SSH into a Linux virtual machine instance and run command
# In: MY_GCP_GCE_NAME, MY_GCP_ZONE, MY_GCP_GCE_SSH_COMMAND
ssh_command
