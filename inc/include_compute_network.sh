#!/usr/bin/env bash

################################################################################
# Compute Engine network
################################################################################

# Create a Compute Engine network (VPC)
function create_network() {
	echo_title "Create a Compute Engine network (VPC) with name '$MY_GCP_NETWORK'"
	echo "Please wait..."
	if ! gcloud compute networks create "$MY_GCP_NETWORK" \
		--subnet-mode=custom \
		--mtu=1460 \
		--bgp-routing-mode=regional \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not create network"
		export MY_WARNING=1
	fi
}

# Define a subnet with IP range for the network
function create_subnet() {
	echo_title "Define a subnet '$MY_GCP_SUBNET' with range '$MY_GCP_SUBNET_RANGE' for the network"
	echo "Please wait..."
	if ! gcloud compute networks subnets create "$MY_GCP_SUBNET" \
		--range="$MY_GCP_SUBNET_RANGE" \
		--network="$MY_GCP_NETWORK" \
		--region="$MY_GCP_REGION" \
		--enable-private-ip-google-access \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not create subnet"
		export MY_WARNING=1
	fi
}

# List all Compute Engine subnets and networks
function list_subnets() {
	echo_title "Compute Engine subnets and networks"
	echo_web "https://console.cloud.google.com/networking/networks/list?project=$MY_GCP_PROJECT"
	if ! gcloud compute networks subnets list  \
		--format="table( name, region, network, ipCidrRange )" \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not list subnets"
		export MY_WARNING=1
	fi
}
