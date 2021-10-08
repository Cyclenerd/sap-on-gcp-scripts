#!/usr/bin/env bash

################################################################################
# Secrets
################################################################################

# Create a new secret
# In: MY_GCP_SECRET_NAME, MY_GCP_SECRET
function create_secret() {
	echo_title "Create a secret with the name '$MY_GCP_SECRET_NAME' and secret data (password)"
	if echo -n "$MY_GCP_SECRET" | gcloud secrets create "$MY_GCP_SECRET_NAME" \
		--replication-policy=user-managed \
		--locations="$MY_GCP_REGION" \
		--project="$MY_GCP_PROJECT" \
		--data-file=-; then
		echo_success "Secret successfully created"
	else
		echo_warning "Could not create secret"
		export MY_WARNING=1
	fi
}

# Get last versions for a secret
# In: MY_GCP_SECRET_NAME
# Out: MY_GCP_SECRET_LAST_VERSION
function get_last_version_secret() {
	echo_title "Get last version for secret '$MY_GCP_SECRET_NAME'"
	gcloud secrets versions list "$MY_GCP_SECRET_NAME" --filter=state=enabled --sort-by=name --project="$MY_GCP_PROJECT"
	MY_GCP_SECRET_LAST_VERSION=$(gcloud secrets versions list "$MY_GCP_SECRET_NAME" \
		--filter=state=enabled \
		--sort-by=name \
		--format="value(name)" \
		--limit=1 \
		--project="$MY_GCP_PROJECT")
	# Check if version greater than 0
	if [[ "$MY_GCP_SECRET_LAST_VERSION" -gt 0 ]]; then
		echo_info "Last version: $MY_GCP_SECRET_LAST_VERSION"
	else
		echo_warning "Could not get last version"
		export MY_WARNING=1
	fi
}

# Add IAM policy binding to a secret
# In: MY_GCP_SA_NAME, MY_GCP_SECRET_NAME
function add_secrets_policy_binding() {
	echo_title "Add IAM policy binding to secret '$MY_GCP_SECRET_NAME'"
	if ! gcloud secrets add-iam-policy-binding "$MY_GCP_SECRET_NAME" \
		--member="serviceAccount:$MY_GCP_SA_ID" \
		--role="roles/secretmanager.secretAccessor" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not list secret names"
		export MY_WARNING=1
	fi
}

# Access a secret version's data
# In: MY_GCP_SECRET_NAME, MY_GCP_SECRET_LAST_VERSION
# Out: MY_GCP_SECRET
function access_secret() {
	echo_title "Access data for version '$MY_GCP_SECRET_LAST_VERSION' of secret '$MY_GCP_SECRET_NAME'"
	echo -n "🔓 Secret data: "
	gcloud secrets versions access "$MY_GCP_SECRET_LAST_VERSION" \
	--secret="$MY_GCP_SECRET_NAME" \
	--project="$MY_GCP_PROJECT"
	echo
}

# List all secret names
function list_secrets() {
	echo_title "List all secret names"
	echo_web "https://console.cloud.google.com/security/secret-manager?project=$MY_GCP_PROJECT"
	if ! gcloud secrets list \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not list secret names"
		export MY_WARNING=1
	fi
}
