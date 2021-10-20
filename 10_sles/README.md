# SUSE Linux Enterprise Server 15

Create service account and Compute Engine virtual machine instance with SUSE Linux Enterprise Server 15 as operating system.

## Configuration

Configuration other than default values:

| Variable | Description | Value |
|----------|-------------|-------|
| MY_GCP_GCE_NAME | Name of GCE virtual machine instance | `sles` |
| MY_GCP_GCE_TYPE | GCE machine type | `g1-small` [vCPU: shared, RAM: 1.7 GB] |
| MY_GCP_GCE_DISK_BOOT_TYPE | Type of the boot disk | `pd-ssd` |
| MY_GCP_GCE_DISK_BOOT_SIZE | Size of the boot disk | `32GB` |
| MY_GCP_GCE_IMAGE_FAMILY | Image family for the OS that the boot disk will be initialized with | `sles-15` |
| MY_GCP_GCE_IMAGE_PROJECT | Project against image family references | `suse-cloud` |

## Pricing

[Google Cloud Pricing Calculator](https://cloud.google.com/products/calculator/#id=246c521f-cae2-4ad5-b787-32cd001330aa)

* Region: Finland
* 730 total hours per month
* VM class: regular
* Instance type: `g1-small` (USD 14.46) [Sustained Use Discount applied]
* Operating System / Software: Paid (USD 14.60)
* Sustained Use Discount: 30%
* Effective Hourly Rate: USD 0.040
* Zonal SSD PD: 32 GiB
* Total Estimated Cost: USD 35.05 per 1 month

SUSE Linux Enterprise Server 15 usage fee billed by Google:

* EUR 0.02/hour (EUR 12.38/month) for `f1-micro` and `g1-small` machine types
* EUR 0.09/hour (EUR 68.12/month) for all other machine types

Information without guarantee.

## Scripts

* `01_create_sles.sh` : Create service account and Compute Engine virtual machine instance
* `10_ssh_sles.sh`    : SSH into a Linux virtual machine instance
* `99_delete_sles.sh` : Delete Compute Engine virtual machine instance and service account


### Snapshots

If you don't need your VM for a long time you can make a snapshot from the disk.
You can then delete the VM and the disk (`99_delete_sles.sh`).
If you need the VM with the data again, you can create a new fresh VM from the snapshot.

* `30_create_snapshot_sles.sh`      : Create snapshot of Compute Engine persistent boot disk
* `31_create_from_snapshot_sles.sh` : Create Compute Engine persistent boot disk from last snapshot and create virtual machine instance with created disk
* `39_delete_snapshots_sles.sh`     : Delete all Compute Engine boot disk snapshots from specific instance

You will then save the [disk cost](https://cloud.google.com/compute/all-pricing#disk) and pay only the very cheap [snapshot price](https://cloud.google.com/compute/all-pricing#disk).

* Regional snapshot storage $0.029 per GB in `europe-north1` (Finland)
* Multi-regional snapshot storage $0.0286 per GB in `eu` (European Union) [DEFAULT]

Example:

```shell
# Create snapshot
bash 30_create_snapshot_sles.sh
# Delete SA, Disk and VM
bash 99_delete_sles.sh
# Later, create new VM from snapshot
bash 31_create_from_snapshot_sles.sh
# Delete all snapshots
bash 39_delete_snapshots_sles.sh
```