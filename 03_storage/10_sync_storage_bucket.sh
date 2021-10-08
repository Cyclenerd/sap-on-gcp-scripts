#!/usr/bin/env bash

# Synchronize local directory to Google Cloud storage bucket

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

# Sync storage bucket
# In: MY_GCP_STORAGE
sync_storage

# Display object size usage
du_storage

echo_info "Synchronize content"
echo "Upload:"
echo "  $ gsutil -m rsync -r $MY_STORAGE_BUCKET_DIR gs://$MY_GCP_STORAGE"
echo
echo "Download:"
echo "  Linux:   gsutil -m rsync -r gs://$MY_GCP_STORAGE ~/Downloads"
echo "  Windows: gsutil -m rsync -r gs://$MY_GCP_STORAGE %HOMEPATH%\Downloads"

echo_web "Browser: https://console.cloud.google.com/storage/browser/$MY_GCP_STORAGE?project=$MY_GCP_PROJECT"

# Check MY_WARNING and exit with echo_success or echo_failure
# In: MY_WARNING
check_warning_and_exit "Storage bucket synchronized successfully"
