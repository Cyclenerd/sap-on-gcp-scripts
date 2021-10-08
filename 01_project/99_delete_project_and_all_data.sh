#!/usr/bin/env bash

# Delete project and all data

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

echo_title "Delete Google Cloud project with ID '$MY_GCP_PROJECT' and all stored data"
if gcloud projects delete "$MY_GCP_PROJECT"; then
	echo_success "Project successfully deleted"
else
	exit_with_failure "Project could not be deleted"
fi
