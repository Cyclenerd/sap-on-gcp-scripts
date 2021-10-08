#!/usr/bin/env bash

################################################################################
# Compute Engine
################################################################################

# Create Compute Engine virtual machine instance
# In: 
#    MY_GCP_GCE_NAME
#    MY_GCP_ZONE
#    MY_GCP_GCE_TYPE
#    MY_GCP_SUBNET
#    MY_GCP_SA_ID
#    MY_GCP_GCE_IMAGE_PROJECT
#    MY_GCP_GCE_IMAGE_FAMILY
#    MY_GCP_GCE_DISK_BOOT_NAME
#    MY_GCP_GCE_DISK_BOOT_SIZE
#    MY_GCP_GCE_STARTUP_SCRIPT_URL
#    MY_GCP_GCE_WINDOWS_STARTUP_SCRIPT_URL
#      https://cloud.google.com/compute/docs/instances/startup-scripts
#
# Allow full access to all Cloud APIs
# Note that the level of access that a service account has is determined by a combination of access scopes and IAM roles
# so you must configure both access scopes and IAM roles for the service account to work properly.
function create_vm() {
	# Copy startup scripts to storage bucket
	copy_startup_storage
	# Create VM
	echo_title "Create Compute Engine virtual machine instance '$MY_GCP_GCE_NAME'"
	echo "Please wait..."
	if ! gcloud compute instances create "$MY_GCP_GCE_NAME" \
		--zone="$MY_GCP_ZONE" \
		--machine-type="$MY_GCP_GCE_TYPE" \
		--subnet="$MY_GCP_SUBNET" \
		--no-address \
		--maintenance-policy=MIGRATE \
		--scopes="cloud-platform" \
		--service-account="$MY_GCP_SA_ID" \
		--image-family="$MY_GCP_GCE_IMAGE_FAMILY" \
		--image-project="$MY_GCP_GCE_IMAGE_PROJECT" \
		--boot-disk-device-name="$MY_GCP_GCE_DISK_BOOT_NAME" \
		--boot-disk-size="$MY_GCP_GCE_DISK_BOOT_SIZE" \
		--boot-disk-type=pd-ssd \
		--no-shielded-secure-boot \
		--shielded-vtpm \
		--shielded-integrity-monitoring \
		--reservation-affinity=any \
		--metadata=startup-script-url="$MY_GCP_GCE_STARTUP_SCRIPT_URL",windows-startup-script-url="$MY_GCP_GCE_WINDOWS_STARTUP_SCRIPT_URL" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not create VM instance"
		export MY_WARNING=1
	else
		echo_info "VM instance is starting... Please wait a few minutes..."
		if [[ "$MY_GCP_GCE_IMAGE_PROJECT" == 'windows'* ]]; then
			echo "RDP into a Windows virtual machine instance:"
			echo "1. Start an IAP TCP forwarding tunnel for RDP"
			echo "   $ gcloud compute start-iap-tunnel $MY_GCP_GCE_NAME 3389 --local-host-port=127.33.8.9:3389 --zone=$MY_GCP_ZONE --project=$MY_GCP_PROJECT"
			echo "2. Connect to local 127.33.8.9 via RDP client"
			echo "   > mstsc /v:127.33.8.9:3389"
			echo
			echo "Connect to serial console:"
			# Windows port 2:
			# https://cloud.google.com/compute/docs/troubleshooting/troubleshooting-using-serial-console#setting_up_a_login_on_other_serial_ports
			echo "$ gcloud compute connect-to-serial-port $MY_GCP_GCE_NAME --port 2 --zone=$MY_GCP_ZONE --project=$MY_GCP_PROJECT"
		else
			echo "SSH into a Linux virtual machine instance:"
			echo "$ gcloud compute ssh $MY_GCP_GCE_NAME --tunnel-through-iap --zone=$MY_GCP_ZONE --project=$MY_GCP_PROJECT"
			echo
			# https://cloud.google.com/compute/docs/instances/startup-scripts/linux#viewing-output
			echo "View output of a Linux startup script:"
			echo "$ sudo journalctl -u google-startup-scripts.service"
			echo
			echo "Connect to serial console:"
			echo "$ gcloud compute connect-to-serial-port $MY_GCP_GCE_NAME --zone=$MY_GCP_ZONE --project=$MY_GCP_PROJECT"
		fi
	fi
}

# Start Compute Engine virtual machine instance
function start_vm() {
	echo_title "Start virtual machine instance '$MY_GCP_GCE_NAME' in zone '$MY_GCP_ZONE'"
	if ! gcloud compute instances start "$MY_GCP_GCE_NAME" \
		--zone="$MY_GCP_ZONE" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not start VM instance"
		export MY_WARNING=1
	fi
}

# Stop Compute Engine virtual machine instance
function stop_vm() {
	echo_title "Stop virtual machine instance '$MY_GCP_GCE_NAME' in zone '$MY_GCP_ZONE'"
	if ! gcloud compute instances stop "$MY_GCP_GCE_NAME" \
		--zone="$MY_GCP_ZONE" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not stop VM instance"
		export MY_WARNING=1
	fi
}

# SSH into a Linux virtual machine instance
# In: MY_GCP_GCE_NAME, MY_GCP_ZONE
function ssh_vm() {
	echo_title "SSH into Linux virtual machine instance '$MY_GCP_GCE_NAME' in zone '$MY_GCP_ZONE'"
	if ! gcloud compute ssh "$MY_GCP_GCE_NAME" \
		--tunnel-through-iap \
		--zone="$MY_GCP_ZONE" \
		--project="$MY_GCP_PROJECT"; then
		echo_failure "Could not SSH into VM"
	fi
}
# SSH into a Linux virtual machine instance and run command
# In: MY_GCP_GCE_NAME, MY_GCP_ZONE, MY_GCP_GCE_SSH_COMMAND
function ssh_command() {
	echo_title "SSH into VM '$MY_GCP_GCE_NAME' in zone '$MY_GCP_ZONE' and run command"
	echo "Please wait..."
	if gcloud compute ssh "$MY_GCP_GCE_NAME" \
		--tunnel-through-iap \
		--zone="$MY_GCP_ZONE" \
		--project="$MY_GCP_PROJECT" \
		--command="$MY_GCP_GCE_SSH_COMMAND"; then
		echo_success "Successfully run command"
	else
		echo_failure "Could not run command"
	fi
}


# Delete Compute Engine virtual machine instance
function delete_vm() {
	echo_title "Delete virtual machine instance '$MY_GCP_GCE_NAME' in zone '$MY_GCP_ZONE'"
	if ! gcloud compute instances delete "$MY_GCP_GCE_NAME" \
		--delete-disks=all \
		--zone="$MY_GCP_ZONE" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not delete VM instance"
		export MY_WARNING=1
	fi
}

# List all Compute Engine virtual machine instances
function list_vms() {
	echo_title "Compute Engine virtual machine instances"
	echo_web "https://console.cloud.google.com/compute/instances?project=$MY_GCP_PROJECT"
	if ! gcloud compute instances list \
		--format="table( name, zone.basename(), networkInterfaces[].networkIP, status )" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not list VM instance"
		export MY_WARNING=1
	fi
}

# Enabling interactive serial console access for all VM instances that are part the project
# https://cloud.google.com/compute/docs/troubleshooting/troubleshooting-using-serial-console#gcloud
function enable_serial_console() {
	echo_title "Enable serial console access for all VMs in project '$MY_GCP_PROJECT'"
	if gcloud compute project-info add-metadata \
		--metadata "serial-port-enable=TRUE" \
		--project="$MY_GCP_PROJECT"; then
		echo "Successfully enabled"
	else
		echo_warning "Could not enable serial console access"
		export MY_WARNING=1
	fi
}

# Check hostname for SAP or exit_with_failure
# In: MY_GCP_GCE_NAME
function check_sap_hostname() {
	if [ ${#MY_GCP_GCE_NAME} -gt 13 ]; then
		echo_title "Check hostname '$MY_GCP_GCE_NAME' for SAP"
		echo "The length of the hostname you have chosen exceeds 13 character,"
		echo "this is not supported by SAP, please use a different hostname."
		exit_with_failure "Ilegal hostname for SAP"
	fi
}