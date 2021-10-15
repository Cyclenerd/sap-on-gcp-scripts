# SUSE Linux Enterprise Server 15 for SAP

Create service account and Compute Engine virtual machine instance with SUSE Linux Enterprise Server 15 for SAP as operating system.

## Configuration

Configuration other than default values:

| Variable | Description | Value |
|----------|-------------|-------|
| MY_GCP_GCE_NAME | Name of GCE virtual machine instance | `slessap` |
| MY_GCP_GCE_TYPE | GCE machine type | `n1-standard-1` |
| MY_GCP_GCE_DISK_BOOT_TYPE | Type of the boot disk | `pd-ssd` |
| MY_GCP_GCE_DISK_BOOT_SIZE | Size of the boot disk | `64GB` |
| MY_GCP_GCE_IMAGE_FAMILY | Image family for the OS that the boot disk will be initialized with | `sles-15-sp3-sap` |
| MY_GCP_GCE_IMAGE_PROJECT | Project against image family references | `suse-sap-cloud` |

## Pricing

[Google Cloud Pricing Calculator](https://cloud.google.com/products/calculator/#id=6b01ac7e-ea27-442a-a1ea-76a00512991b)

* Region: Finland
* 730 total hours per month
* VM class: regular
* Instance type: `n1-standard-1` (USD 26.70) [Sustained Use Discount applied]
* Operating System / Software: Paid (USD 124.10)
* Sustained Use Discount: 30%
* Effective Hourly Rate: USD 0.207
* Estimated Component Cost: USD 150.80 per 1 month
* Zonal SSD PD: 64 GiB
* Total Estimated Cost: USD 162.77 per 1 month

SUSE Linux Enterprise Server 15 for SAP usage fee billed by Google:

* EUR 0.14/hour (EUR 105.27/month) for 1-2 vCPU machine types
* EUR 0.29/hour (EUR 210.55/month) for 3-4 vCPU machine types
* EUR 0.35/hour (EUR 253.90/month) for 5+  vCPU machine types

Information without guarantee.

## Scripts

* `01_create_slessap.sh` : Create service account and Compute Engine virtual machine instance
* `10_ssh_slessap.sh`    : SSH into a Linux virtual machine instance
* `99_delete_slessap.sh` : Delete Compute Engine virtual machine instance and service account
