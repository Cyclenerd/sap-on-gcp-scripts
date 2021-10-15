#!/usr/bin/env bash

# Install SAP NetWeaver AS ABAP Developer Edition 7.52 SP04 on virtual machine instance

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

# Local checks
MY_LOCAL_INSTALLATION_DIR="$MY_STORAGE_BUCKET_DIR""sapnw752sp4"
MY_LOCAL_INSTALLATION_SHA256SUMS="9a70dbb29935abfa9a64de35d8ec7fdc2f381e4913dd3e4d82f66f7537c8608e  $MY_LOCAL_INSTALLATION_DIR/install.sh
cc3e387c433ab626e667c78e49531892d22ad8dbea8c4b762f43da12f185473b  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/dbdata.tgz-aa
c935396b518ad267edad84f8b5c851c15f805fa970bf2d751dc8007851e84ceb  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/dbdata.tgz-ab
4a362f8ef4a04982fe9c83429652841585d4e7b0c60cfbbb25472a8ba053432a  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/dbdata.tgz-ac
e6919f48640bb354d8ec22e2dc315cfa2ca079320c0d108e0753b21d11c1b1a8  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/dbdata.tgz-ad
77e53f5759ad2ae5adc046b27856f829b123420e435037f1901f944012811e92  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/dbdata.tgz-ae
cd2ea0ba603b7665efd38f715fa77484b204e37c7bcfdc16db5fd8714f7881f4  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/dbexe.tgz-aa
a671173af45d8389057e24f9f3a35f42b6551a86bda4cd338255bd093a8b5a96  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/dblog.tgz-aa
58d960844d49787719cc9d9249d36553c14bdd38fa036213e7cc447fea9a3050  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/IdCard.xml
488098df09916b60ea46c278d4c9b6eca6f6c59c2f5d95f374e56fbdb9adeac5  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/SAPHOSTAGENT42_42-20009394.SAR
4fed61e5de4511ccbaaa0f8561dee2efc7da32c62f888447082d4fc2a1b1d3be  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/sapinst.txt
85f474e4bc43b8aa7e8940ec1010c6f6f24a2e363e58072317c58d5f88dc44a7  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/sapmnt.tgz-aa
adafb196704de496e32e9ad6fc578777c7cc997282d16e5461b98788a62e0181  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/SAP_Software_Appliance.xml
b2e3ff78cdc43294c5cab718f816fe654a52070010b7534633164e52847bbcd9  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/SWPM10SP25_0-20009701.SAR
7be7f2aa2e8543ac3fa4da1bde9eb451041d0d2f11ad74f640daf16cbc1841e9  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/SYBASE_ASE_TestDrive.lic
3254f666591ff05c49b8a1d7583db2f98e62c38413ff29d3684222711eaba74a  $MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/usrsap.tgz-aa"

echo_title "Check local installation directory '$MY_LOCAL_INSTALLATION_DIR'"
if [ ! -d "$MY_LOCAL_INSTALLATION_DIR" ]; then
	exit_with_failure "Local installation directory not found"
fi
echo "✓ OK"
echo_title "Check local patch file 'install_gce.patch'"
# diff -u install.sh install_gce.sh > install_gce.patch
if [ ! -f "install_gce.patch" ]; then
	exit_with_failure "Local patch file not found"
fi
echo "✓ OK"
echo_title "Check local installation script from SAP '$MY_LOCAL_INSTALLATION_DIR/install.sh'"
if [ ! -f "$MY_LOCAL_INSTALLATION_DIR/install.sh" ]; then
	exit_with_failure "Local installation script from SAP not found"
fi
echo "✓ OK"
MY_LOCAL_INSTALLATION_ASE_LICENSE="$MY_LOCAL_INSTALLATION_DIR/server/TAR/x86_64/SYBASE_ASE_TestDrive.lic"
echo_title "Check local ASE TestDrive license file '$MY_LOCAL_INSTALLATION_ASE_LICENSE'"
if [ ! -f "$MY_LOCAL_INSTALLATION_ASE_LICENSE" ]; then
	exit_with_failure "Local ASE TestDrive license file not found"
fi
echo "✓ OK"
if ! grep "will expire March 31st 2022" < "$MY_LOCAL_INSTALLATION_ASE_LICENSE" > /dev/null; then
	echo_warning "File 'SYBASE_ASE_TestDrive.lic' from original 'License.rar' with release date 21-Feb-2021 not found"
	export MY_WARNING=1
fi
echo_title "Check the SHA256 checksums of important files to be on the safe side"
if sha256sum --check <<<"$MY_LOCAL_INSTALLATION_SHA256SUMS"; then
	echo "✓ OK"
else
	echo_warning "Not all checksums are correct. Try to continue anyway..."
fi

# Generate a valid SAP master password
echo_title "Generate a valid SAP master password"
echo "This password is need for the OS users:"
echo "  - sapadm"
echo "  - npladm"
echo "  - sybnpl"
echo "The password will be stored in Google Secret Manager."
echo "During the actual installation on the server, the password is securely accessed from the Google Secret Manager."
generate_password
if ! [[ "$MY_PASSWORD" =~ ^[A-Z] ]]; then
	exit_with_failure "Could not generate password"
fi

# Create a new secret and store password
# In: MY_GCP_SECRET_NAME, MY_GCP_SECRET
export MY_GCP_SECRET="$MY_PASSWORD"
create_secret

# Get service account identifier or exit_with_failure
# In: MY_GCP_SA_NAME
# Out: MY_GCP_SA_ID
get_service_account_identifier

# Add IAM policy binding to a secret
# In: MY_GCP_SA_NAME, MY_GCP_SECRET_NAME
add_secrets_policy_binding

# Get last versions for a secret
# In: MY_GCP_SECRET_NAME
# Out: MY_GCP_SECRET_LAST_VERSION
get_last_version_secret

# Patch install script
echo_title "Copy installation script from SAP"
if ! cp -v "$MY_LOCAL_INSTALLATION_DIR/install.sh" "$MY_LOCAL_INSTALLATION_DIR/install_gce.sh"; then
	exit_with_failure "Could not copy installation script"
fi
echo_title "Patch installation script for unattended installation"
if ! patch -u "$MY_LOCAL_INSTALLATION_DIR/install_gce.sh" -i "install_gce.patch"; then
	exit_with_failure "Could not patch installation script '$MY_LOCAL_INSTALLATION_DIR/install_gce.sh'"
fi
echo_title "Replace secret name to '$MY_GCP_SECRET_NAME' and last version to '$MY_GCP_SECRET_LAST_VERSION'"
if ! sed -i "s/MY_GCP_SECRET_NAME/$MY_GCP_SECRET_NAME/g" "$MY_LOCAL_INSTALLATION_DIR/install_gce.sh"; then
	exit_with_failure "Could not replace secret name in file '$MY_LOCAL_INSTALLATION_DIR/install_gce.sh'"
fi
if ! sed -i "s/MY_GCP_SECRET_LAST_VERSION/$MY_GCP_SECRET_LAST_VERSION/g" "$MY_LOCAL_INSTALLATION_DIR/install_gce.sh"; then
	exit_with_failure "Could not replace secret version in file '$MY_LOCAL_INSTALLATION_DIR/install_gce.sh'"
fi
echo "✓ Sucessfully replaced"

# Sync storage bucket
# In: MY_GCP_STORAGE
echo_title "Synchronize local installation directory to remote storage bucket"
echo "The upload will take some time depending on your bandwidth."
echo "You can also do it with the script '10_sync_storage_bucket.sh' in the directory '03_storage'."
sync_storage

# Remote checks
echo_title "Check remote patched installation script 'gs://$MY_GCP_STORAGE/sapnw752sp4/install_gce.sh'"
if ! gsutil ls -r "gs://$MY_GCP_STORAGE/sapnw752sp4/*" | grep "install_gce.sh" > /dev/null; then
	exit_with_failure "Remote install_gce.sh files not found"
fi
echo "✓ OK"
echo_title "Check remote ASE TestDrive license file 'gs://$MY_GCP_STORAGE/sapnw752sp4/server/TAR/x86_64/SYBASE_ASE_TestDrive.lic'"
if ! gsutil ls -r "gs://$MY_GCP_STORAGE/sapnw752sp4/server/TAR/x86_64/*" | grep "SYBASE_ASE_TestDrive.lic" > /dev/null; then
	exit_with_failure "Remote SYBASE_ASE_TestDrive.lic files not found"
fi
echo "✓ OK"


export MY_GCP_GCE_SSH_COMMAND="
# Download
sudo mkdir '/tmp/sapnw752sp4'
echo '» Download installation source'
if ! sudo /root/google-cloud-sdk/bin/gsutil -m rsync -r 'gs://$MY_GCP_STORAGE/sapnw752sp4' '/tmp/sapnw752sp4'; then
	echo '× Could not download installation source from bucket'
	exit 1
fi
echo '✓ OK'
echo '» Test access version '$MY_GCP_SECRET_LAST_VERSION' of secret '$MY_GCP_SECRET_NAME' from Google Secret Manager'
if ! sudo /root/google-cloud-sdk/bin/gcloud secrets versions access '$MY_GCP_SECRET_LAST_VERSION' --secret='$MY_GCP_SECRET_NAME' > /dev/null; then
	echo '× Could not access secret'
	exit 1
fi
echo '✓ OK'
# Install
if ! sudo bash '/tmp/sapnw752sp4/install_gce.sh'; then
	echo '× Could not install SAP'
	exit 1
fi
echo '✓ OK'
exit 0
"

# SSH into a Linux virtual machine instance and run command
# In: MY_GCP_GCE_NAME, MY_GCP_ZONE, MY_GCP_GCE_SSH_COMMAND
ssh_command

# Check MY_WARNING and exit with echo_success or echo_failure
# In: MY_WARNING
check_warning_and_exit "SAP installed successfully"
