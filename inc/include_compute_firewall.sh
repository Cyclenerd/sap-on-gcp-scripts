#!/usr/bin/env bash

################################################################################
# Compute Engine firewall
################################################################################

# Firewall rules
# SSH: 22
# RDP: 3389
# SAP Dispatcher: 3200-3299
# Gateway: 3300-3399
# Message server: 3600-3699
# HTTP: 80
# ICM HTTP: 8000-8999
# HTTPS: 443
# ICM HTTPS: 44300-44399
# SAP Central Services: 50000-59999
declare -A MY_GCP_FIREWALL_RULES
MY_GCP_FIREWALL_RULES=(
	["Ping"]="icmp"
	["SSH"]="tcp:22"
	["RDP"]="tcp:3389"
	["SAP"]="tcp:3200-3299,tcp:3300-3399,tcp:3600-3699,tcp:80,tcp:8000-8999,tcp:443,tcp:44300-44399,tcp:50000-59999"
)

# Create firewall rules
function create_firewall_rules() {
	for MY_GCP_FIREWALL_RULE in "${!MY_GCP_FIREWALL_RULES[@]}"; do
		MY_GCP_FIREWALL_ALLOW="${MY_GCP_FIREWALL_RULES[$MY_GCP_FIREWALL_RULE]}"
		echo_title "Create firewall rule to allow $MY_GCP_FIREWALL_RULE ($MY_GCP_FIREWALL_ALLOW) in private network"
		if ! gcloud compute firewall-rules create "firewall-allow-${MY_GCP_FIREWALL_RULE,,}" \
			--network "$MY_GCP_NETWORK" \
			--allow "$MY_GCP_FIREWALL_ALLOW" \
			--project="$MY_GCP_PROJECT"; then
			echo_warning "Could not create firewall rule"
			export MY_WARNING=1
		fi
	done
}

# List all firewall rules
function list_firewall_rules() {
	echo_title "Firewall rules"
	echo_web "https://console.cloud.google.com/networking/firewalls/list?project=$MY_GCP_PROJECT"
	if ! gcloud compute firewall-rules list  \
		--project="$MY_GCP_PROJECT"; then
		echo_warning "Could not list firewall rules"
		export MY_WARNING=1
	fi
}