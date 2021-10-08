#!/usr/bin/env bash

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
echo_success "Functions included"

################################################################################
# MAIN
################################################################################

#echo_title "Accounts"
#gcloud auth list --format="table[box](account,status)"


#echo_failure "Text"
#echo_warning "Text"
#echo_success "Text"

echo_title "System Information"
uname -a

echo_title "Bash Version"
echo "${BASH_VERSION}"

echo_title "gcloud Version"
gcloud version

echo_title "gsutil Version"
gsutil version -l

echo_title "Variables"
debug_variables

generate_password
echo_key "Password: $MY_PASSWORD"

export MY_WARNING=0
check_warning_and_exit "Custom text"
