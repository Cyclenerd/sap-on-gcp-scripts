#!/usr/bin/env bash

################################################################################
# Auth
################################################################################

# Check active account or exit
function check_auth() {
	MY_GCP_ACCOUNT=$(gcloud auth list --filter="status:ACTIVE" --format="value(account)" --limit=1)
	if [[ "$MY_GCP_ACCOUNT" == *'@'* ]]; then
		echo_key "Active Google Cloud Platform account: $MY_GCP_ACCOUNT"
	else
		tput setaf 1 0 0 # 1 = red
		echo_equals
		echo "× NOT AUTHENTICATED"
		echo_equals
		echo
		echo "  To authenticate a user account with gcloud, run:"
		echo "    $ gcloud auth login --brief"
		echo
		echo_equals
		tput sgr0  # reset terminal
		echo
		exit 2
	fi
}
