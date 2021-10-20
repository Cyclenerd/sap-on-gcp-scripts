#!/usr/bin/env bash

################################################################################
# DEFAULTS
# Please do not modify anything here.
# Variables are overwritten by the 'config' file.
################################################################################

# Scripts
MY_SCRIPT_NAME=$(basename "$0")
export MY_SCRIPT_NAME

# Project
export MY_GCP_SHORT_NAME=${MY_GCP_SHORT_NAME:-"demo"}
export MY_GCP_FOLDER=${MY_GCP_FOLDER:-""}
export MY_GCP_PROJECT=${MY_GCP_PROJECT:-"sandbox-$MY_GCP_SHORT_NAME"}
export MY_GCP_REGION=${MY_GCP_REGION:-"europe-north1"}
export MY_GCP_ZONE=${MY_GCP_ZONE:-"$MY_GCP_REGION-c"}
if [ ${#MY_GCP_SERVICES[@]} -eq 0 ]; then
	export MY_GCP_SERVICES=(
		'compute.googleapis.com'
		'dns.googleapis.com'
		'cloudresourcemanager.googleapis.com'
		'secretmanager.googleapis.com'
	)
fi

# Network
export MY_GCP_NETWORK=${MY_GCP_NETWORK:-"network-$MY_GCP_SHORT_NAME"}
export MY_GCP_SUBNET=${MY_GCP_SUBNET:-"subnet-$MY_GCP_REGION"}
export MY_GCP_SUBNET_RANGE=${MY_GCP_SUBNET_RANGE:-"192.168.201.0/24"}

# Router
export MY_GCP_ROUTER=${MY_GCP_ROUTER:-"router-$MY_GCP_REGION"}
export MY_GCP_NAT=${MY_GCP_NAT:-"nat-$MY_GCP_REGION"}

# Storage
export MY_GCP_STORAGE=${MY_GCP_STORAGE:-"share-$MY_GCP_SHORT_NAME"}

# Compute Engine virtual machine instance
export MY_GCP_GCE_NAME=${MY_GCP_GCE_NAME:-"default-name"}
export MY_GCP_GCE_TYPE=${MY_GCP_GCE_TYPE:-"e2-micro"}
export MY_GCP_GCE_STARTUP_SCRIPT_URL=${MY_GCP_GCE_STARTUP_SCRIPT_URL:-"gs://$MY_GCP_STORAGE/startup/linux_startup_script.sh"}
export MY_GCP_GCE_WINDOWS_STARTUP_SCRIPT_URL=${MY_GCP_GCE_WINDOWS_STARTUP_SCRIPT_URL:-"gs://$MY_GCP_STORAGE/startup/windows_startup_script.ps1"}
export MY_GCP_GCE_SSH_COMMAND=${MY_GCP_GCE_SSH_COMMAND:-"uname -a"}

# Compute Engine persistent disks
export MY_GCP_GCE_IMAGE_FAMILY=${MY_GCP_GCE_IMAGE_FAMILY:-"debian-10"}
export MY_GCP_GCE_IMAGE_PROJECT=${MY_GCP_GCE_IMAGE_PROJECT:-"debian-cloud"}
export MY_GCP_GCE_DISK_BOOT_NAME=${MY_GCP_GCE_DISK_BOOT_NAME:-"disk-boot-$MY_GCP_GCE_NAME"}
export MY_GCP_GCE_DISK_BOOT_TYPE=${MY_GCP_GCE_DISK_BOOT_TYPE:-"pd-ssd"}
export MY_GCP_GCE_DISK_BOOT_SIZE=${MY_GCP_GCE_DISK_BOOT_SIZE:-"32GB"}
export MY_GCP_GCE_SNAPSHOT_STORAGE_LOCATION=${MY_GCP_GCE_SNAPSHOT_STORAGE_LOCATION:-"eu"}

# Secrets
export MY_GCP_SECRET=${MY_GCP_SECRET:-""}
export MY_GCP_SECRET_NAME=${MY_GCP_SECRET_NAME:-"sec-$MY_GCP_GCE_NAME"}
export MY_GCP_SECRET_LAST_VERSION=${MY_GCP_SECRET_LAST_VERSION:-"1"}

# IAM
export MY_GCP_SA_NAME=${MY_GCP_SA_NAME:-"sa-gce-$MY_GCP_GCE_NAME"}
export MY_GCP_SA_DISPLAY_NAME=${MY_GCP_SA_DISPLAY_NAME:-"GCE $MY_GCP_GCE_NAME"}
export MY_GCP_SA_DESCRIPTION=${MY_GCP_SA_DESCRIPTION:-"Service account for Google Compute Engine server $MY_GCP_GCE_NAME"}
# Default IAM roles (policy binding) for service account
if [ ${#MY_GCP_SA_ROLES[@]} -eq 0 ]; then
	export MY_GCP_SA_ROLES=(
		'roles/logging.logWriter'
		'roles/monitoring.metricWriter'
		'roles/monitoring.viewer'
	)
fi
export MY_GCP_SA_FILE=${MY_GCP_SA_FILE:-"private_key_""$MY_GCP_SA_NAME""_JSON.json"}

# Images
export MY_GCP_IMAGE=${MY_GCP_IMAGE:-"debian-10-buster-v20210916"}
export MY_GCP_IMAGE_PROJECT=${MY_GCP_IMAGE_PROJECT:-"debian-cloud"}

# Local IP for RDP tunnel
export MY_RDP_LOCAL=${MY_RDP_LOCAL:-"127.19.72.6"}

# Local IP for SAP GUI tunnel
export MY_GUI_LOCAL=${MY_GUI_LOCAL:-"127.19.72.3"}

# Reset warnings
export MY_WARNING=0

# debug_variables() print all script global variables to ease debugging
function debug_variables() {
	echo "USER: $USER" # Current operating system username
	echo "SHELL: $SHELL" # Current shell
	echo "BASH_VERSION: $BASH_VERSION"
	echo "MY_SCRIPT_NAME: $MY_SCRIPT_NAME"
	echo
	echo "MY_CONFIG: $MY_CONFIG"
	echo "MY_STORAGE_BUCKET_DIR: $MY_STORAGE_BUCKET_DIR"
	echo "MY_STORAGE_STARTUP_DIR: $MY_STORAGE_STARTUP_DIR"
	echo "MY_STORAGE_STARTUP_SCRIPT: $MY_STORAGE_STARTUP_SCRIPT"
	echo "MY_STORAGE_WINDOWS_STARTUP_SCRIPT: $MY_STORAGE_WINDOWS_STARTUP_SCRIPT"
	echo
	echo "MY_GCP_ACCOUNT: $MY_GCP_ACCOUNT"
	echo "MY_GCP_SHORT_NAME: $MY_GCP_SHORT_NAME"
	echo "MY_GCP_PROJECT: $MY_GCP_PROJECT"
	echo "MY_GCP_FOLDER [OPTIONAL]: $MY_GCP_FOLDER"
	echo "MY_GCP_REGION: $MY_GCP_REGION"
	echo "MY_GCP_ZONE: $MY_GCP_ZONE"
	echo "MY_GCP_ROUTER: $MY_GCP_ROUTER"
	echo "MY_GCP_NETWORK: $MY_GCP_NETWORK"
	echo "MY_GCP_SUBNET: $MY_GCP_SUBNET"
	echo "MY_GCP_SUBNET_RANGE: $MY_GCP_SUBNET_RANGE"
	echo "MY_GCP_NAT: $MY_GCP_NAT" 
	echo "MY_GCP_STORAGE: $MY_GCP_STORAGE"
	echo "MY_GCP_GCE_NAME: $MY_GCP_GCE_NAME"
	echo "MY_GCP_GCE_TYPE: $MY_GCP_GCE_TYPE"
	echo "MY_GCP_GCE_IMAGE_FAMILY: $MY_GCP_GCE_IMAGE_FAMILY"
	echo "MY_GCP_GCE_IMAGE_PROJECT: $MY_GCP_GCE_IMAGE_PROJECT"
	echo "MY_GCP_GCE_DISK_BOOT_NAME: $MY_GCP_GCE_DISK_BOOT_NAME"
	echo "MY_GCP_GCE_DISK_BOOT_TYPE: $MY_GCP_GCE_DISK_BOOT_TYPE"
	echo "MY_GCP_GCE_DISK_BOOT_SIZE: $MY_GCP_GCE_DISK_BOOT_SIZE"
	echo "MY_GCP_GCE_SNAPSHOT_STORAGE_LOCATION: $MY_GCP_GCE_SNAPSHOT_STORAGE_LOCATION"
	echo "MY_GCP_GCE_STARTUP_SCRIPT_URL: $MY_GCP_GCE_STARTUP_SCRIPT_URL"
	echo "MY_GCP_GCE_WINDOWS_STARTUP_SCRIPT_URL: $MY_GCP_GCE_WINDOWS_STARTUP_SCRIPT_URL"
	echo "MY_GCP_GCE_SSH_COMMAND: $MY_GCP_GCE_SSH_COMMAND"
	echo "MY_GCP_SA_NAME: $MY_GCP_SA_NAME"
	echo "MY_GCP_SA_DISPLAY_NAME: $MY_GCP_SA_DISPLAY_NAME"
	echo "MY_GCP_SA_DESCRIPTION: $MY_GCP_SA_DESCRIPTION"
	echo "MY_GCP_SA_ROLES: ${MY_GCP_SA_ROLES[*]}"
	echo "MY_GCP_SA_FILE: $MY_GCP_SA_FILE"
	echo "MY_GCP_SECRET_NAME: $MY_GCP_SECRET_NAME"
	echo "MY_GCP_SECRET_LAST_VERSION: $MY_GCP_SECRET_LAST_VERSION"
	echo "MY_RDP_LOCAL: $MY_RDP_LOCAL"
	echo "MY_GUI_LOCAL: $MY_GUI_LOCAL"
}