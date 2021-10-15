#!/usr/bin/env bash

# Starts an IAP TCP forwarding tunnel for RDP

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

clear
# ASCII art title
tput setaf 4 0 0 # 4 = blue
echo_equals
cat << EOF
  _____  _____  _____    _______                     _ 
 |  __ \|  __ \|  __ \  |__   __|                   | |
 | |__) | |  | | |__) |    | |_   _ _ __  _ __   ___| |
 |  _  /| |  | |  ___/     | | | | | '_ \| '_ \ / _ \ |
 | | \ \| |__| | |         | | |_| | | | | | | |  __/ |
 |_|  \_\_____/|_|         |_|\__,_|_| |_|_| |_|\___|_|

EOF
echo_equals
tput sgr0  # reset terminal
echo_info "Tunnel local IP '$MY_RDP_LOCAL' port 3389 to '$MY_GCP_GCE_NAME' port 3389 for RDP"
echo
echo
echo "Connect to '$MY_GCP_GCE_NAME' via RDP:"
echo "> mstsc /v:$MY_RDP_LOCAL:3389"
echo
echo_info "Exit with [Ctrl] + [C]"
echo
gcloud compute start-iap-tunnel "$MY_GCP_GCE_NAME" 3389 \
	--local-host-port="$MY_RDP_LOCAL:3389" \
	--zone="$MY_GCP_ZONE" \
	--project="$MY_GCP_PROJECT"
