#!/usr/bin/env bash

# Access secret version's data

################################################################################
# DEFAULTS
# Please do not modify anything here.
# Variables are overwritten by the 'config' file.
################################################################################

export MY_GCP_GCE_NAME="sapnw752sp4"
export MY_GCP_SECRET_NAME="sec-""$MY_GCP_GCE_NAME""-sap-os"

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

# Get last versions for a secret
# In: MY_GCP_SECRET_NAME
# Out: MY_GCP_SECRET_LAST_VERSION
get_last_version_secret

# Access secret version's data
# In: MY_GCP_SECRET_NAME, MY_GCP_SECRET_LAST_VERSION
# Out: MY_GCP_SECRET
access_secret
