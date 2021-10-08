#!/usr/bin/env bash

# SSH into a Linux virtual machine instance and install packages

################################################################################
# DEFAULTS
# Please do not modify anything here.
# Variables are overwritten by the 'config' file.
################################################################################

export MY_GCP_GCE_NAME="debian"

export MY_GCP_GCE_SSH_COMMAND="
# Update
sudo apt-get update
# Install package
sudo apt-get install -qq locales dialog screen htop mtr
# Uncomment en_US.UTF-8 for inclusion in generation
sudo sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
# Generate locale
sudo locale-gen
# Upgrade
sudo apt-get dist-upgrade -qq
# dotfiles
curl -f 'https://raw.githubusercontent.com/Cyclenerd/dotfiles/master/screenrc' -o ~/.screenrc
"

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

# SSH into a Linux virtual machine instance and run command
# In: MY_GCP_GCE_NAME, MY_GCP_ZONE, MY_GCP_GCE_SSH_COMMAND
ssh_command
