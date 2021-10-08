#!/usr/bin/env bash

# Connecting to the serial console

################################################################################
# DEFAULTS
# Please do not modify anything here.
# Variables are overwritten by the 'config' file.
################################################################################

export MY_GCP_GCE_NAME="windows"

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

echo_title "Connect to serial console of VM instance '$MY_GCP_GCE_NAME'"
echo
echo 'To disconnect from the serial console:'
echo ' 1. Press the ENTER key'
echo ' 2. Type ~. (tilde, followed by a period).'
echo
sleep 3
gcloud compute connect-to-serial-port "$MY_GCP_GCE_NAME" \
	--port 2 \
	--zone="$MY_GCP_ZONE" \
	--project="$MY_GCP_PROJECT"
