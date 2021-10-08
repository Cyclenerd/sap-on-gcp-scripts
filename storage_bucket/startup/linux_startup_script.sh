#!/usr/bin/bash

MY_FIRST_BOOT_FILE='/root/.first_boot_DO_NOT_DELETE'

# Google Cloud Ops agent
MY_ADD_AGENT_REPO_URL='https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh'
MY_ADD_AGENT_REPO_SCRIPT='/root/add-google-cloud-ops-agent-repo.sh'

# Google Cloud SDK
MY_CLOUD_SDK_URL='https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-358.0.0-linux-x86_64.tar.gz'
MY_CLOUD_SDK_TAR='/root/google-cloud-sdk.tar.gz'

if [ -f "$MY_FIRST_BOOT_FILE" ]; then
	echo "✓ Initial setup already done"
else
	echo "» Initial setup"

	echo "› Install the latest version of the Google Cloud Ops agent"
	curl -sS "$MY_ADD_AGENT_REPO_URL" -o "$MY_ADD_AGENT_REPO_SCRIPT" >  "/root/google-ops-agent.log"
	bash "$MY_ADD_AGENT_REPO_SCRIPT" --also-install                  >> "/root/google-ops-agent.log"

	echo "› Install Google Cloud SDK"
	curl -sS "$MY_CLOUD_SDK_URL" -o "$MY_CLOUD_SDK_TAR"    >  "/root/google-cloud-sdk.log"
	tar xvfz "$MY_CLOUD_SDK_TAR" --directory "/root/"      >> "/root/google-cloud-sdk.log"
	sh "/root/google-cloud-sdk/install.sh" --quiet         >> "/root/google-cloud-sdk.log"
	/root/google-cloud-sdk/bin/gcloud auth list            >> "/root/google-cloud-sdk.log"

	echo "✓ Done"
	date > "$MY_FIRST_BOOT_FILE"
fi