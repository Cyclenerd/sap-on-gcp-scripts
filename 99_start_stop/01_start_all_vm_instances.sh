#!/usr/bin/env bash

# Start all Compute Engine virtual machine instances in project

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

echo_title "Start all Compute Engine virtual machine instances"
MY_GCP_GCE_INSTANCES=$(gcloud compute instances list --format="csv[no-heading](name, zone)" --project="$MY_GCP_PROJECT")
# Loop instances
while IFS=',' read -r MY_GCP_GCE_NAME MY_GCP_ZONE || [[ -n "$MY_GCP_ZONE" ]]; do
	export MY_GCP_GCE_NAME
	export MY_GCP_ZONE
	# Start Compute Engine virtual machine instance
	# In: MY_GCP_GCE_NAME, MY_GCP_ZONE
	start_vm
done <<<"$MY_GCP_GCE_INSTANCES"

echo_web "VM instances: https://console.cloud.google.com/compute/instances?project=$MY_GCP_PROJECT"
