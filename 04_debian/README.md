# Debian

Create service account and Compute Engine virtual machine instance with Debian as operating system.

## Configuration

Configuration other than default values:

| Variable | Description | Value |
|----------|-------------|-------|
| MY_GCP_GCE_NAME | Name of GCE virtual machine instance | `debian` |
| MY_GCP_GCE_TYPE | GCE machine type | `e2-micro` [vCPUs: 2 (shared), RAM: 1GB] |
| MY_GCP_GCE_DISK_BOOT_TYPE | Type of the boot disk | `pd-ssd` |
| MY_GCP_GCE_DISK_BOOT_SIZE | Size of the boot disk | `32GB` |
| MY_GCP_GCE_IMAGE_FAMILY | Image family for the OS that the boot disk will be initialized with | `debian-10` |
| MY_GCP_GCE_IMAGE_PROJECT | Project against image family references | `debian-cloud` |

## Pricing

[Google Cloud Pricing Calculator](https://cloud.google.com/products/calculator/#id=20043b60-057a-4105-a73e-504f7af20e74)

* Region: Finland
* 730 total hours per month
* VM class: regular
* Instance type: `e2-micro`
* Operating System / Software: Free
* Zonal SSD PD: 32 GiB
* Total Estimated Cost: USD 12.71 per 1 month

Information without guarantee.

## Scripts

* `01_create_debian.sh`           : Create service account and Compute Engine virtual machine instance
* `10_ssh_debian.sh`              : SSH into a Linux virtual machine instance
* `20_install_debian_packages.sh` : SSH into a Linux virtual machine instance and install packages
* `99_delete_debian.sh`           : Delete Compute Engine virtual machine instance and service account
* `ZZ_debug.sh`                   : For debugging only

## OS

Become root:

```
sudo -i
```
