#!/usr/bin/env bash

################################################################################
# Service account
################################################################################

# Create service account
function create_service_account() {
	echo_title "Create service account '$MY_GCP_SA_NAME'"
	if gcloud iam service-accounts create "$MY_GCP_SA_NAME" \
		--display-name="$MY_GCP_SA_DISPLAY_NAME" \
		--description="$MY_GCP_SA_DESCRIPTION" \
		--project="$MY_GCP_PROJECT"; then
		# Wait a bit until the service account has been activated
		wait_a_bit
	else
		echo_warning "Could not create service account"
		export MY_WARNING=1
	fi
}

# Get service account identifier or exit_with_failure
function get_service_account_identifier() {
	echo_title "Get service account identifier"
	gcloud iam service-accounts list \
		--filter="email ~ ^$MY_GCP_SA_NAME\@" \
		--project="$MY_GCP_PROJECT"
	MY_GCP_SA_ID=$(gcloud iam service-accounts list --filter="email ~ ^$MY_GCP_SA_NAME\@" --format="value(email)" --project="$MY_GCP_PROJECT")
	if [[ "$MY_GCP_SA_ID" == *'@'* ]]; then
		echo_info "Service account identifier: $MY_GCP_SA_ID"
	else
		exit_with_failure "Service account identifier could not be detected"
	fi
}

# Delete service account
function delete_service_account() {
	echo_title "Delete service account '$MY_GCP_SA_ID'"
	if ! gcloud iam service-accounts delete "$MY_GCP_SA_ID" --project="$MY_GCP_PROJECT"; then
		echo_warning "Could not delete service account"
		export MY_WARNING=1
	fi
}

# List all service accounts
function list_service_accounts() {
	echo_title "Service accounts"
	echo_web "https://console.cloud.google.com/iam-admin/serviceaccounts?project=$MY_GCP_PROJECT"
	if ! gcloud iam service-accounts list \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not list service accounts"
		export MY_WARNING=1
	fi
}


################################################################################
# Service account key
################################################################################

# Create a private key for service account identifier
function create_service_account_key() {
	echo_title "Create a private key for service account identifier '$MY_GCP_SA_ID'"
	if ! gcloud iam service-accounts keys create "$MY_GCP_SA_FILE" \
		--iam-account="$MY_GCP_SA_ID" \
		--project="$MY_GCP_PROJECT"; then
		echo_failure "Could not create private key"
		export MY_WARNING=1
	fi
}

# Delete all user-managed keys from a service account
function delete_all_service_account_keys() {
	echo_title "Delete all user-managed keys from service account '$MY_GCP_SA_ID'"
	MY_GCP_GCE_SA_KEYS=$(gcloud iam service-accounts keys list \
		--managed-by=user \
		--format="csv[no-heading](name)" \
		--iam-account="$MY_GCP_SA_ID" \
		--project="$MY_GCP_PROJECT"
	)
	# Loop keys
	while IFS=',' read -r MY_GCP_GCE_SA_KEY_ID || [[ -n "$MY_GCP_GCE_SA_KEY_ID" ]]; do
		echo_title "Delete key '$MY_GCP_GCE_SA_KEY_ID' from service account"
		if ! gcloud iam service-accounts keys delete "$MY_GCP_GCE_SA_KEY_ID" \
			--quiet \
			--iam-account="$MY_GCP_SA_ID" \
			--project="$MY_GCP_PROJECT"; then
			echo_warning "Could not delete private key"
			export MY_WARNING=1
		fi
	done <<<"$MY_GCP_GCE_SA_KEYS"
}

# List the keys for a service account
# Print (cat) private key
function print_service_account_key() {
	echo_title "Private key '$MY_GCP_SA_FILE'"
	cat "$MY_GCP_SA_FILE" || echo_failure "Can not read private key"
}

# Delete private key
function delete_service_account_key() {
	echo_title "Delete private key '$MY_GCP_SA_FILE'"
	rm "$MY_GCP_SA_FILE" || echo_failure "Can not delete private key"
}
