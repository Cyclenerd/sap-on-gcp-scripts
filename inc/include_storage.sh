#!/usr/bin/env bash

################################################################################
# Storage
################################################################################

# Create Google Cloud storage bucket or exit_with_failure
# https://cloud.google.com/storage/docs/gsutil/commands/mb
function create_storage() {
	echo_title "Create Google Cloud storage bucket '$MY_GCP_STORAGE'"
	if ! gsutil mb -p "$MY_GCP_PROJECT" -c STANDARD -l "$MY_GCP_REGION" -b on gs://"$MY_GCP_STORAGE"; then
		exit_with_failure "Could not create storage"
	fi
}

# Delete storage bucket
# https://cloud.google.com/storage/docs/gsutil/commands/rb
function delete_storage() {
	echo_title "Delete storage bucket '$MY_GCP_STORAGE'"
	if ! gsutil rb gs://"$MY_GCP_STORAGE"; then
		echo_warning "Could not delete storage bucket"
		export MY_WARNING=1
	fi
}

# Add service account read access to storage bucket
# https://cloud.google.com/storage/docs/gsutil/commands/iam
function add_read_access_storage() {
	echo_title "Add '$MY_GCP_SA_ID' read access to storage bucket '$MY_GCP_STORAGE'"
	if ! gsutil iam ch serviceAccount:"$MY_GCP_SA_ID":objectViewer gs://"$MY_GCP_STORAGE"; then
		echo_warning "Could not add read access"
		export MY_WARNING=1
	else
		echo "Read access added"
	fi
}

# Remove service account read access from storage bucket
# https://cloud.google.com/storage/docs/gsutil/commands/iam
function remove_read_access_storage() {
	echo_title "Remove '$MY_GCP_SA_ID' read access from storage bucket '$MY_GCP_STORAGE'"
	if ! gsutil iam ch -d serviceAccount:"$MY_GCP_SA_ID":objectViewer gs://"$MY_GCP_STORAGE"; then
		echo_warning "Could not remove read access"
		export MY_WARNING=1
	else
		echo "Read access removed"
	fi

}

# Copy file to storage bucket
# https://cloud.google.com/storage/docs/gsutil/commands/cp
function copy_file_storage() {
	MY_SOURCE="$1"
	MY_TARGET="$2"
	echo_title "Copy file to storage bucket"
	echo       "Source: '$MY_SOURCE'"
	echo       "Target: '$MY_TARGET'"
	if ! gsutil cp "$MY_SOURCE" "$MY_TARGET"; then
		echo_warning "Could not copy file"
		export MY_WARNING=1
	fi
}

# Copy startup scripts to storage bucket
function copy_startup_storage() {
	echo_title "Copy startup scripts $MY_STORAGE_STARTUP_DIR/* to gs://$MY_GCP_STORAGE/startup/"
	if ! gsutil cp -r "$MY_STORAGE_STARTUP_DIR/"* gs://"$MY_GCP_STORAGE"/startup/; then
		echo_warning "Could not copy startup scripts"
		export MY_WARNING=1
	fi
}

# Sync storage bucket
# https://cloud.google.com/storage/docs/gsutil/commands/rsync
function sync_storage() {
	echo_title "Synchronize '$MY_STORAGE_BUCKET_DIR' content to gs://$MY_GCP_STORAGE"
	if ! gsutil -m rsync -r "$MY_STORAGE_BUCKET_DIR" gs://"$MY_GCP_STORAGE"; then
		echo_warning "Could not synchronize files"
		export MY_WARNING=1
	fi
}

# Display object size usage
# https://cloud.google.com/storage/docs/gsutil/commands/du
function du_storage() {
	echo_title "Storage usage '$MY_GCP_STORAGE'"
	if ! gsutil du -s -h gs://"$MY_GCP_STORAGE"; then
		echo_warning "Could not get object size usage"
		export MY_WARNING=1
	fi
}

# Delete object from storage bucket
# https://cloud.google.com/storage/docs/gsutil/commands/rm
function delete_file_storage() {
	MY_TARGET="$1"
	echo_title "Delete object '$MY_TARGET'"
	if ! gsutil rm "$MY_TARGET"; then
		echo_warning "Could not delete file"
		export MY_WARNING=1
	fi
}

# List all storage buckets
function list_storage() {
	echo_title "Storage buckets"
	echo_web "https://console.cloud.google.com/storage/browser?project=$MY_GCP_PROJECT"
	if ! gsutil ls \
		-p "$MY_GCP_PROJECT"; then
		echo_warning "Could not list buckets"
		export MY_WARNING=1
	fi
}
