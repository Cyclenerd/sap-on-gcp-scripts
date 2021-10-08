# SAP on Google Cloud Platform Boilerplate

A collection of Bash shell scripts with which you can quickly create your own Virtual Private Cloud (VPC) in the Google Cloud Platform.
In your VPC you can then start various servers.
Including Windows Server and SAP NetWeaver AS ABAP Developer Edition 7.52 SP04.

With this set of shell scripts you get the same setup on a small scale as with [large SAP on GCP projects](https://www.otto.de/jobs/technology/techblog/artikel/cloud-native-sap-operation-in-the-otto-group.php).

## Requirement

### Google Cloud

* Google Cloud account
* Valid Cloud Billing account (even if you are in your free trial period)

### Local

* GNU Bourne Again SHell
	* `bash` (Version >= 4)
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
	* `gcloud` (Version >= 357.0.0)
	* `gsutil` (Version >= 4.67)
* GNU coreutils
	* `sha256sum`
	* `grep`
	* `sed`
	* `patch`
	* `tr`
	* `tput`

## Tested

* Ubuntu on Windows (Windows Subsystem for Linux)

## Architecture

* Default region: `europe-north1` (Finland)
* Default zone: `europe-north1-c`
* Default name of the subnetwork: `subnet-europe-north1`
* The IP space allocated to the subnetwork: `192.168.201.0/24`

The following diagram shows the architecture for a default deployment of SAP NetWeaver AS ABAP Developer Edition 7.52 SP04:

```text
 +--------------------------------------------------------------------------+
 | Region: europe-north1                                                    |
 |                                                                          |
 | Cloud Storage (share-demo)                                               |
 |                                                                          |
 | +---------------------------------------------------------------------+  |
 | | Virtual Private Cloud Network (network-demo)                        |  |
 | |                                                                     |  |
 | | Cloud Router (router-europe-north1) with NAT (nat-europe-north1)    |  |
 | |                                                                     |  |
 | | +----------------------------------------------------------------+  |  |
 | | | Private Subnet (subnet-europe-north1): 192.168.201.0/24        |  |  |
 | | | +------------------------------------------------------------+ |  |  |
 | | | | Zone: europe-north1-c                                      | |  |  |
 | | | |                                                            | |  |  |
 | | | | » Compute Engine Instance (sapnw752sp4)                    | |  |  |
 | | | | › Persistent Disk (ssd-boot-sapnw752sp4)                   | |  |  |
 | | | +------------------------------------------------------------+ |  |  |
 | | +----------------------------------------------------------------+  |  |
 | +---------------------------------------------------------------------+  |
 +--------------------------------------------------------------------------+
```

## Setup

You can do the whole setup with the Bash scripts.
Default values can be overwritten with a configuration file `config` in the folder.

I recommend you to change the default name (variable `MY_GCP_STORAGE`) of the Google Storage bucket.
To do this, create a file named `config` in this folder:

```shell
# Overwrite defaults
echo "MY_GCP_STORAGE=my-random-storage-name-123" > config
```

The further setup until your first server looks like this:
```shell
# Project
cd 01_project/
bash 01_create_project.sh
bash 02_enable_services.sh
cd ../
# Network
cd 02_network/
bash 01_create_network.sh
cd ../
# Storage
cd 03_storage/
bash 01_create_storage_bucket.sh
cd ../
# First server
cd 04_debian/
bash 01_create_debian.sh
# SSH into server
bash 10_ssh_debian.sh
cd ../
# List
cd 01_project/
bash 10_list_project.sh
```

### Initial

1. [Create project and enable billing](01_project/)
1. [Enable APIs and services](01_project/)
1. [Create a Virtual Private Cloud (VPC)](02_create_network/)
1. [Create Google Cloud storage bucket](03_storage/)

### Server and Services

* [Debian Server](04_debian/)
* [Windows Server](05_windows/) with SAP GUI for Windows and Google Chrome
* [SUSE Linux Enterprise Server 15](10_sles/)
* [SUSE Linux Enterprise Server 15 for SAP](10_sles_for_sap/)
* [SAP NetWeaver AS ABAP Developer Edition 7.52 SP04](15_sap_nw_752_sp4/)
* [SAP Cloud Appliance Library](30_sap_cal/)

### Second Region and Network

* Region: `europe-west4` (Netherlands)
* Zone: `europe-west4-c`
* Name of the subnetwork: `subnet-europe-west4`
* The IP space allocated to the subnetwork: `192.168.204.0/24`

1. [Create a second Virtual Private Cloud (VPC)](25_2nd_region_and_network/)
1. [Debian Server](25_2nd_region_and_network/)

## Helper

* [Start & stop all VMs](99_start_stop/)
* [Delete project and all data](01_project/)
* [More commands](90_more_commands/)

## FAQ

* Q: Why shell scripts and not Ansible, Teraform, etc.?
* A: Ansible is another dependency you need to understand as well. Most people in the SAP area already know shell scripts. Therefore shell scripts.

## TODO

* Documentation of all default variables
* Run [SAP HANA, express edition](https://hub.docker.com/_/sap-hana-express-edition) in Container-Optimized OS

## Contributing

Have a patch that will benefit this project?
Awesome! Follow these steps to have it accepted.

1. Please read [how to contribute](CONTRIBUTING.md).
1. Fork this Git repository and make your changes.
1. Create a Pull Request.
1. Incorporate review feedback to your changes.
1. Accepted!

## License

All files in this repository are under the [Apache License, Version 2.0](LICENSE) unless noted otherwise.
