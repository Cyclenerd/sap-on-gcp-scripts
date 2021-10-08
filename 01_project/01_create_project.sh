#!/usr/bin/env bash

# Create project and enable billing

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

# Get first acitive billing account or exit_with_failure
get_billing_account

# Create new project or exit_with_failure
# In: MY_GCP_PROJECT, MY_GCP_FOLDER
create_project

# Enable billing for the new project or exit_with_failure
enable_billing

# Done
echo_success "Project successfully created"
