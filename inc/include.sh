#!/usr/bin/env bash

if [[ ! $LC_CTYPE ]]; then
	export LC_CTYPE='en_US.UTF-8'
fi
if [[ ! $LC_ALL ]]; then
	export LC_ALL='en_US.UTF-8'
fi

################################################################################
# FUNCTIONS
################################################################################

# command_exists() tells if a given command exists.
function command_exists() {
	command -v "$1" >/dev/null 2>&1
}

# check_command() check if command exists and exit if not exists
function check_command() {
	if ! command_exists "$1"; then
		exit_with_failure "Command '$1' not found"
	fi
}

# echo_equals() outputs a line with =
#   seq does not exist under OpenBSD
function echo_equals() {
	NCOLS=$(tput cols)
	COUNTER=0
	while [  $COUNTER -lt "$NCOLS" ]; do
		printf '='
		(( COUNTER=COUNTER+1 ))
	done
}

# echo_title() outputs a text in cyan
function echo_title() {
	tput setaf 4 0 0 # 4 = blue
	echo_equals
	echo "👉 $1"
	echo_equals
	tput sgr0  # reset terminal
	echo
}

# echo_info() outputs a text in cyan
function echo_info() {
	tput setaf 6 0 0 # 6 = cyan
	echo_equals
	echo "💡 $1"
	echo_equals
	tput sgr0  # reset terminal
}

# echo_key() outputs a text in cyan
function echo_key() {
	tput setaf 6 0 0 # 6 = cyan
	echo_equals
	echo "🔑 $1"
	echo_equals
	tput sgr0  # reset terminal
}

# echo_web() outputs a text in cyan
function echo_web() {
	tput setaf 6 0 0 # 6 = cyan
	echo_equals
	echo "🧭 $1"
	echo_equals
	tput sgr0  # reset terminal
}

# echo_success() outputs a text in green.
function echo_success() {
	tput setaf 2 0 0 # 2 = green
	echo_equals
	echo "✅ OK: $1"
	echo_equals
	tput sgr0  # reset terminal
	echo
}

# echo_warning() outputs a text in yellow
function echo_warning() {
	tput setaf 3 0 0 # 3 = yellow
	echo_equals
	echo "⚠️ WARNING: $1"
	echo_equals
	tput sgr0  # reset terminal
	echo
}

# echo_failure() outputs a text in red
function echo_failure() {
	tput setaf 1 0 0 # 1 = red
	echo_equals
	echo "🟥 FAILURE: $1"
	echo_equals
	tput sgr0  # reset terminal
	echo
}

# exit_with_failure() outputs a message before exiting the script.
function exit_with_failure() {
	echo_failure "$1"
	exit 1
}

# Check MY_WARNING and exit with echo_success or echo_failure
function check_warning_and_exit() {
	MY_SUCCESS_TEXT="All steps set up successfully"
	if [[ ! -z "$1" ]]; then
		MY_SUCCESS_TEXT="$1"
	fi
	if [ "$MY_WARNING" -eq "0" ]; then
		echo_success "$MY_SUCCESS_TEXT"
		exit 0
	else
		echo_failure "Not all steps were successfully. Please check."
		exit 1
	fi
}

function wait_a_bit() {
	MY_SLEEP=0
	MY_SLEEP_SEC=30
	echo_title "Sleeping for $MY_SLEEP_SEC seconds…"
	echo "Sometimes the last step takes until everything is activated properly."
	echo "Therefore, we better wait $MY_SLEEP_SEC seconds to be on the safe side."
	while [ "$MY_SLEEP" -le "$MY_SLEEP_SEC" ]
	do
		sleep 1
		echo -n "."
		MY_SLEEP=$((MY_SLEEP+1))
	done
	echo
}

################################################################################
# Check bash version and tput
################################################################################

if ! [[ "${BASH_VERSION}" =~ ^[4,5] ]]; then
	echo "× Bash version 4 or 5 is required"
	echo "  Your bash version is: '${BASH_VERSION}'"
	exit 9
fi

if ! command_exists tput; then
	echo "× Command 'tput' not found"
	exit 9
fi

################################################################################
# Load more include files
################################################################################

MY_INCLUDE_FILES=(
	'include_auth.sh'
	'include_billing.sh'
	'include_compute.sh'
	'include_compute_firewall.sh'
	'include_compute_network.sh'
	'include_compute_router.sh'
	'include_iam.sh'
	'include_password.sh'
	'include_projects.sh'
	'include_secrets.sh'
	'include_services.sh'
	'include_storage.sh'
	'include_config.sh'
	'include_defaults.sh' # Important! Always as last source.
)
MY_INCLUDE_DIR='./inc/'
if [[ "$MY_INCLUDE" == '../'* ]]; then
	MY_INCLUDE_DIR='../inc/'
fi
for MY_INCLUDE_FILE in "${MY_INCLUDE_FILES[@]}"; do
	MY_INCLUDE_FILE="$MY_INCLUDE_DIR""$MY_INCLUDE_FILE"
	# ignore SC1090
	# shellcheck source=/dev/null
	if ! source "$MY_INCLUDE_FILE"; then
		exit_with_failure "× Can not read required include file '$MY_INCLUDE_FILE'"
	fi
done

################################################################################
# Welcome text
################################################################################

echo_web "Google Cloud Dashboard: https://console.cloud.google.com/home/dashboard?&project=$MY_GCP_PROJECT"
