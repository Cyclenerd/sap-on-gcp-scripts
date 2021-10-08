#!/usr/bin/env bash

################################################################################
# Billing
################################################################################

# Manage billing account
# https://cloud.google.com/billing/docs/how-to/modify-project#enable_billing_for_a_new_project

# Get first acitive billing account or exit_with_failure
function get_billing_account() {
	echo_title "Get first active billing account"
	gcloud beta billing accounts list --filter=open=true
	MY_GCP_BILLING_ACCOUNT=$(gcloud beta billing accounts list --filter=open=true --format="value(name)" --limit=1)
	if [[ "$MY_GCP_BILLING_ACCOUNT" =~ ^[A-Z0-9-]+$ ]]; then
		echo_info "Billing Account ID: $MY_GCP_BILLING_ACCOUNT"
	else
		exit_with_failure "Billing account could not be detected"
	fi
}

# Enable billing for the new project or exit_with_failure
function enable_billing() {
	echo_title "Link billing account '$MY_GCP_BILLING_ACCOUNT' to project '$MY_GCP_PROJECT'"
	if ! gcloud beta billing projects link "$MY_GCP_PROJECT" --billing-account="$MY_GCP_BILLING_ACCOUNT"; then
		exit_with_failure "Billing could not be linked"
	fi
}
