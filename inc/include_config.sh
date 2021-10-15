#!/usr/bin/env bash

################################################################################
# Config
################################################################################

MY_STORAGE_BUCKET_DIR='./storage_bucket/'

# Load custom config file
if [[ "$MY_INCLUDE" == '../inc/'* ]]; then
	MY_CONFIG='../config'
	MY_STORAGE_BUCKET_DIR='../storage_bucket/'
	if [ -e "$MY_CONFIG" ]; then
		echo_info "Load config file '$MY_CONFIG'"
		# ignore SC1090
		# shellcheck source=/dev/null
		source "$MY_CONFIG"
	fi
fi
# Load default config file
MY_DEFAULT_CONFIG='default_config'
if [ -e "$MY_DEFAULT_CONFIG" ]; then
	echo_info "Load default config file '$MY_DEFAULT_CONFIG'"
	# ignore SC1090
	# shellcheck source=/dev/null
	source "$MY_DEFAULT_CONFIG"
fi
# Load custom config file
MY_CONFIG='config'
if [ -e "$MY_CONFIG" ]; then
	echo_info "Load config file '$MY_CONFIG'"
	# ignore SC1090
	# shellcheck source=/dev/null
	source "$MY_CONFIG"
fi

################################################################################
# Check config and local setup
################################################################################

# Check storage dir
if [ ! -d "$MY_STORAGE_BUCKET_DIR" ]; then
	exit_with_failure "Cannot locate storage folder '$MY_STORAGE_BUCKET_DIR'"
fi
export MY_STORAGE_BUCKET_DIR

# Check startup storage dir
MY_STORAGE_STARTUP_DIR="$MY_STORAGE_BUCKET_DIR""startup"
if [ ! -d "$MY_STORAGE_STARTUP_DIR" ]; then
	exit_with_failure "Cannot locate startup storage folder '$MY_STORAGE_STARTUP_DIR'"
fi
export MY_STORAGE_STARTUP_DIR

# Check Windows startup script
MY_STORAGE_WINDOWS_STARTUP_SCRIPT="$MY_STORAGE_BUCKET_DIR""startup/windows_startup_script.ps1"
if [ ! -r "$MY_STORAGE_WINDOWS_STARTUP_SCRIPT" ]; then
	exit_with_failure "Cannot read default Windows startup script '$MY_STORAGE_WINDOWS_STARTUP_SCRIPT'"
fi

# Check default Linux startup script
MY_STORAGE_STARTUP_SCRIPT="$MY_STORAGE_BUCKET_DIR""startup/linux_startup_script.sh"
if [ ! -r "$MY_STORAGE_STARTUP_SCRIPT" ]; then
	exit_with_failure "Cannot read default Linux startup script '$MY_STORAGE_STARTUP_SCRIPT'"
fi
export MY_STORAGE_STARTUP_SCRIPT

################################################################################
# Check required programs or exit
################################################################################

check_command gcloud
check_command gsutil
check_command sha256sum
check_command grep
check_command sed
check_command tr
check_command patch

################################################################################
# Check active Google Cloud account or exit
################################################################################

check_auth
