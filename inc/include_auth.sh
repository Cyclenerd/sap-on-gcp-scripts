#!/usr/bin/env bash

################################################################################
# Auth
################################################################################

# Check active account or exit
function check_auth() {
	MY_GCP_ACCOUNT=$(gcloud auth list --filter="status:ACTIVE" --format="value(account)" --limit=1)
	if [[ "$MY_GCP_ACCOUNT" == *'@'* ]]; then
		if [[ "$HIDE_MY_GCP_ACCOUNT" ]]; then
			MY_SHA_ACCOUNT=$(echo -n "$MY_GCP_ACCOUNT" | sha256sum | grep -o '[a-zA-Z0-9]' | tr -d '\n');
			echo_key "Active GCP account: $MY_SHA_ACCOUNT (hashed)"
		else
			echo_key "Active Google Cloud Platform account: $MY_GCP_ACCOUNT"
		fi
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
