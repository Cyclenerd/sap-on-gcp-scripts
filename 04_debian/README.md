# Debian

Create service account and Compute Engine virtual machine instance with Debian as operating system.

## Configuration

Configuration other than default values:

| Variable | Description | Value |
|----------|-------------|-------|
| MY_GCP_GCE_NAME | Name of GCE virtual machine instance | `debian` |
| MY_GCP_GCE_TYPE | GCE machine type | `e2-micro` [vCPUs: 2 (shared), RAM: 1GB] |
| MY_GCP_GCE_DISK_BOOT_TYPE | Type of the boot disk | `pd-ssd` |
| MY_GCP_GCE_DISK_BOOT_SIZE | Size of the boot disk | `16GB` |
| MY_GCP_GCE_IMAGE_FAMILY | Image family for the OS that the boot disk will be initialized with | `debian-10` |
| MY_GCP_GCE_IMAGE_PROJECT | Project against image family references | `debian-cloud` |

## Pricing

[Google Cloud Pricing Calculator](https://cloud.google.com/products/calculator/#id=f1175c02-3d07-4f88-a02b-74cb517db62d)

* Region: Finland
* 730 total hours per month
* VM class: regular
* Instance type: `e2-micro`
* Operating System / Software: Free
* Zonal SSD PD: 16 GiB (USD 2.99) [When the instance is shut down, you only pay the price for this disc.]
* Total Estimated Cost: USD 9.72 per 1 month

Information without guarantee.

## Scripts

* `01_create_debian.sh`               : Create service account and Compute Engine virtual machine instance
* `10_ssh_debian.sh`                  : SSH into a Linux virtual machine instance
* `20_install_debian_packages.sh`     : SSH into a Linux virtual machine instance and install packages
* `99_delete_debian.sh`               : Delete Compute Engine virtual machine instance and service account
* `ZZ_debug.sh`                       : For debugging only

### Snapshots

If you don't need your VM for a long time you can make a snapshot from the disk.
You can then delete the VM and the disk (`99_delete_debian.sh`).
If you need the VM with the data again, you can create a new fresh VM from the snapshot.

* `30_create_snapshot_debian.sh`      : Create snapshot of Compute Engine persistent boot disk
* `31_create_from_snapshot_debian.sh` : Create Compute Engine persistent boot disk from last snapshot and create virtual machine instance with created disk
* `39_delete_snapshots_debian.sh`     : Delete all Compute Engine boot disk snapshots from specific instance

You will then save the [disk cost](https://cloud.google.com/compute/all-pricing#disk) and pay only the very cheap [snapshot price](https://cloud.google.com/compute/all-pricing#disk).

* Regional snapshot storage $0.029 per GB in `europe-north1` (Finland)
* Multi-regional snapshot storage $0.0286 per GB in `eu` (European Union) [DEFAULT]

Example:

```shell
# Create snapshot
bash 30_create_snapshot_debian.sh
# Delete SA, Disk and VM
bash 99_delete_debian.sh
# Later, create new VM from snapshot
bash 31_create_from_snapshot_debian.sh
# Delete all snapshots
bash 39_delete_snapshots_debian.sh
```

## OS

Become root:

```
sudo -i
```
