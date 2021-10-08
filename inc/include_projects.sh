#!/usr/bin/env bash

################################################################################
# Projects
################################################################################

# Creates a new project with the given project ID (MY_GCP_PROJECT) or exit_with_failure.
# By default, projects are not created under a parent resource.
# To use a folder as a parent resource please set MY_GCP_FOLDER to the ID of the folder.
# TODO: set custom organization to use as a parent (--organization=GCP_ORGANIZATION)
function create_project() {
	if [[ "$MY_GCP_FOLDER" =~ ^[0-9]+$ ]]; then
		echo_title "Create new Google Cloud project with ID '$MY_GCP_PROJECT' with parent folders '$MY_GCP_FOLDER'"
		if ! gcloud projects create "$MY_GCP_PROJECT" --folder="$MY_GCP_FOLDER"; then
			exit_with_failure "Project could not be created"
		fi
	else
		echo_title "Create new Google Cloud project with ID '$MY_GCP_PROJECT'"
		if ! gcloud projects create "$MY_GCP_PROJECT"; then
			exit_with_failure "Project could not be created"
		fi
	fi
}

# Add IAM policy binding for role
function add_projects_policy_binding() {
	# shellcheck disable=SC2153
	for MY_GCP_SA_ROLE in "${MY_GCP_SA_ROLES[@]}"; do
		echo_title "Add IAM policy binding for role '$MY_GCP_SA_ROLE'"
		if gcloud projects add-iam-policy-binding "$MY_GCP_PROJECT" \
			--member=serviceAccount:"$MY_GCP_SA_ID" \
			--role="$MY_GCP_SA_ROLE"; then
			echo "Successfully added"
		else
			echo_warning "Could not add role '$MY_GCP_SA_ROLE'"
			export MY_WARNING=1
		fi
	done
}
