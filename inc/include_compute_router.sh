#!/usr/bin/env bash

################################################################################
# Compute Engine router
################################################################################

# Create a Compute Engine router
function create_router() {
	echo_title "Create a Compute Engine router with name '$MY_GCP_ROUTER' for the network"
	if ! gcloud compute routers create "$MY_GCP_ROUTER" \
		--network="$MY_GCP_NETWORK" \
		--region="$MY_GCP_REGION" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not create router"
		export MY_WARNING=1
	fi
}

# Add NAT to a Compute Engine router
function create_nat() {
	echo_title "Add NAT with name '$MY_GCP_NAT' to the Compute Engine router"
	# https://cloud.google.com/nat/docs/using-nat
	# Set min-ports-per-vm to fix SLES zypper
	if ! gcloud compute routers nats create "$MY_GCP_NAT" \
		--router="$MY_GCP_ROUTER"  \
		--auto-allocate-nat-external-ips \
		--nat-all-subnet-ip-ranges \
		--enable-logging \
		--log-filter=ERRORS_ONLY \
		--min-ports-per-vm=256 \
		--region="$MY_GCP_REGION" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not add NAT"
		export MY_WARNING=1
	fi
}

# List all Compute Engine routers
function list_routers() {
	echo_title "Compute Engine routers"
	echo_web "https://console.cloud.google.com/hybrid/routers/list?project=$MY_GCP_PROJECT"
	if ! gcloud compute routers list  \
		--format="table( name, region, network )" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not list routers"
		export MY_WARNING=1
	fi
}

# List all non-dynamic Google Compute Engine routes
function list_routes() {
	echo_title "Compute Engine routes"
	echo_web "https://console.cloud.google.com/networking/routes/list?project=$MY_GCP_PROJECT"
	if ! gcloud compute routes list  \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not list routes"
		export MY_WARNING=1
	fi
}