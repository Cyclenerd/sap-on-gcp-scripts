#!/usr/bin/env bash

################################################################################
# Compute Engine persistent disks
################################################################################

# Create snapshot of Compute Engine persistent boot disk
# In:
#    MY_GCP_GCE_NAME
#    MY_GCP_GCE_DISK_BOOT_NAME
#    MY_GCP_GCE_SNAPSHOT_STORAGE_LOCATION
#    MY_GCP_ZONE
#    MY_GCP_PROJECT
#
# https://cloud.google.com/sdk/gcloud/reference/compute/disks/snapshot
# --storage-location=LOCATION
#    Google Cloud Storage location, either regional or multi-regional, where snapshot content is to be stored.
function create_snapshot() {
	echo_title "Create snapshot of boot disk '$MY_GCP_GCE_DISK_BOOT_NAME' in zone '$MY_GCP_ZONE' and store it in '$MY_GCP_GCE_SNAPSHOT_STORAGE_LOCATION'"
	if ! gcloud compute disks snapshot "$MY_GCP_GCE_DISK_BOOT_NAME" \
		--storage-location="$MY_GCP_GCE_SNAPSHOT_STORAGE_LOCATION" \
		--labels="vm=$MY_GCP_GCE_NAME,boot=yes" \
		--zone="$MY_GCP_ZONE" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not create snapshot"
		export MY_WARNING=1
	fi
}

# Get last Compute Engine boot disk snapshot from specific instance
# In: MY_GCP_GCE_NAME
# Out: MY_GCE_SNAPSHOT_NAME
function get_last_snapshot_vm() {
	echo_title "Get last boot disk snapshot from instance '$MY_GCP_GCE_NAME'"
	gcloud compute snapshots list \
		--filter="labels.vm=$MY_GCP_GCE_NAME AND labels.boot=yes" \
		--sort-by="creationTimestamp" \
		--format="table(name,creationTimestamp,sourceDisk,labels.vm,labels.boot,storageBytes)" \
		--project="$MY_GCP_PROJECT"
	MY_GCE_SNAPSHOT_NAME=$(gcloud compute snapshots list \
		--filter="labels.vm=$MY_GCP_GCE_NAME AND labels.boot=yes" \
		--sort-by="creationTimestamp" \
		--format="value(name)" \
		--project="$MY_GCP_PROJECT" | tail -n1)
	if [[ "$MY_GCE_SNAPSHOT_NAME" =~ ^[a-z] ]]; then
		echo_info "Last snapshot name: $MY_GCE_SNAPSHOT_NAME"
	else
		exit_with_failure "Last snapshot could not be detected"
	fi
}

# Use snapshot to create a new boot disk
# In: MY_GCE_SNAPSHOT_NAME, MY_GCP_GCE_DISK_BOOT_NAME, MY_GCP_GCE_DISK_BOOT_TYPE
function create_disk_from_snapshot() {
	echo_title "Create boot disk '$MY_GCP_GCE_DISK_BOOT_NAME' in zone '$MY_GCP_ZONE' from '$MY_GCE_SNAPSHOT_NAME'"
	echo_wait
	if ! gcloud compute disks create "$MY_GCP_GCE_DISK_BOOT_NAME" \
		--source-snapshot="$MY_GCE_SNAPSHOT_NAME" \
		--type="$MY_GCP_GCE_DISK_BOOT_TYPE" \
		--labels="vm=$MY_GCP_GCE_NAME,boot=yes" \
		--zone="$MY_GCP_ZONE" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not create snapshot"
		export MY_WARNING=1
	fi
}

# Delete all Compute Engine boot disk snapshots from specific instance
# In: MY_GCP_GCE_NAME
function delete_all_snapshots_vm() {
	echo_title "Delete all boot disk snapshots from instance '$MY_GCP_GCE_NAME'"
	gcloud compute snapshots list \
		--filter="labels.vm=$MY_GCP_GCE_NAME AND labels.boot=yes" \
		--sort-by="creationTimestamp" \
		--format="table(name,creationTimestamp,sourceDisk)" \
		--project="$MY_GCP_PROJECT"
	MY_GCE_VM_BOOT_SNAPSHOT_NAMES=$(gcloud compute snapshots list \
		--filter="labels.vm=$MY_GCP_GCE_NAME AND labels.boot=yes" \
		--sort-by="creationTimestamp" \
		--format="csv[no-heading](name,id)" \
		--project="$MY_GCP_PROJECT")
	# Loop snapshot name
	while IFS=',' read -r MY_GCE_SNAPSHOT_NAME MY_GCE_SNAPSHOT_ID || [[ -n "$MY_GCE_SNAPSHOT_ID" ]]; do
		export MY_GCE_SNAPSHOT_NAME
		export MY_GCE_SNAPSHOT_ID
		# Delete snapshot
		# In: MY_GCE_SNAPSHOT_NAME
		delete_snapshot
	done <<<"$MY_GCE_VM_BOOT_SNAPSHOT_NAMES"
}

# Delete Compute Engine snapshot
# In: MY_GCE_SNAPSHOT_NAME
function delete_snapshot() {
	echo_title "Delete snapshot '$MY_GCE_SNAPSHOT_NAME'"
	echo_wait
	if ! gcloud compute snapshots delete "$MY_GCE_SNAPSHOT_NAME" \
		--quiet \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not delete snapshot"
		export MY_WARNING=1
	fi
}

# List all Compute Engine persistent disks
function list_disks() {
	echo_title "Compute Engine persistent disks"
	echo_web "https://console.cloud.google.com/compute/disks?project=$MY_GCP_PROJECT"
	if ! gcloud compute disks list \
		--project="$MY_GCP_PROJECT"; then
		export MY_WARNING=1
	fi
}

# List all Compute Engine disk snapshots
function list_snapshots() {
	echo_title "Compute Engine snapshots"
	echo_web "https://console.cloud.google.com/compute/snapshots?project=$MY_GCP_PROJECT"
	if ! gcloud compute snapshots list \
		--format="table(name,creationTimestamp,sourceDisk,labels.vm,labels.boot,storageBytes)" \
		--project="$MY_GCP_PROJECT"; then
		export MY_WARNING=1
	fi
}