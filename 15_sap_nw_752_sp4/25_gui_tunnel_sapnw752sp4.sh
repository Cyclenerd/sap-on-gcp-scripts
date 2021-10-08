#!/usr/bin/env bash

# Starts an IAP TCP forwarding tunnel for SAP GUI

################################################################################
# DEFAULTS
# Please do not modify anything here.
# Variables are overwritten by the 'config' file.
################################################################################

export MY_GCP_GCE_NAME="sapnw752sp4"
export MY_RDP_LOCAL='127.7.52.4'

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
   _____         _____     _____ _    _ _____    
  / ____|  /\   |  __ \   / ____| |  | |_   _|   
 | (___   /  \  | |__) | | |  __| |  | | | |     
  \___ \ / /\ \ |  ___/  | | |_ | |  | | | |     
  ____) / ____ \| |______| |__| | |__| |_| |_  _ 
 |_____/_/    \_\_|__   __\_____|\____/|_____|| |
                     | |_   _ _ __  _ __   ___| |
                     | | | | | '_ \| '_ \ / _ \ |
                     | | |_| | | | | | | |  __/ |
                     |_|\__,_|_| |_|_| |_|\___|_|
EOF
echo_equals
tput sgr0  # reset terminal
echo_info "Tunnel local IP '$MY_RDP_LOCAL' port 3200 to '$MY_GCP_GCE_NAME' port 3200 for SAP GUI"
echo
echo
echo "Connect to '$MY_GCP_GCE_NAME' via SAP GUI:"
echo "> sapgui $MY_RDP_LOCAL 00"
echo
echo_info "Exit with [Ctrl] + [C]"
echo
gcloud compute start-iap-tunnel "$MY_GCP_GCE_NAME" 3200 \
	--local-host-port="$MY_RDP_LOCAL:3200" \
	--zone="$MY_GCP_ZONE" \
	--project="$MY_GCP_PROJECT"
