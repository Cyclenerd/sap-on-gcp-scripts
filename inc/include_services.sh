#!/usr/bin/env bash

################################################################################
# Services (APIs)
################################################################################

# Enable services
function enable_services() {
	# shellcheck disable=SC2153
	for MY_GCP_SERVICE in "${MY_GCP_SERVICES[@]}"; do
		echo_title "Enable service '$MY_GCP_SERVICE'"
		echo "Please wait..."
		if gcloud services enable "$MY_GCP_SERVICE" --project="$MY_GCP_PROJECT"; then
			echo "Successfully activated"
		else
			echo_warning "Could not activate service '$MY_GCP_SERVICE'"
			export MY_WARNING=1
		fi
	done
}
