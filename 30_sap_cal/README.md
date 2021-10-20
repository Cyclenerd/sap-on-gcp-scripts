# SAP Cloud Appliance Library

Create a service account and private key JSON for [SAP Cloud Appliance Library](https://cal.sap.com/).

> SAP Cloud Appliance Library offers a quick and easy way to consume the latest SAP solutions in the cloud, such as SAP S/4HANA, SAP HANA Express Edition, Model Company Solutions, Industry Solutions etc.
> 
> It's an online library of latest, preconfigured, ready-to-use SAP solutions that can be instantly deployed into your own public cloud accounts (e.g. [...] Google Cloud Platform) to kick-start your SAP projects - within few hours!

## Configuration

Configuration other than default values:

| Variable | Description | Value |
|----------|-------------|-------|
| MY_GCP_SA_NAME | Name of the new service account | `sa-sap-cal` |
| MY_GCP_SA_DISPLAY_NAME | Textual name to display for the account | SAP Cloud Appliance Library |
| MY_GCP_SA_DESCRIPTION | Textual description for the account | Service account for SAP Cloud Appliance Library |
| MY_GCP_SA_ROLES | Roles | `roles/compute.instanceAdmin.v1`, `roles/compute.networkAdmin`, `roles/compute.securityAdmin` |


## Scripts

* `01_create_sap_cal_service_account.sh` : Create a service account for the SAP Cloud Appliance Library
* `02_details_for_sap_cal.sh`            : Show details and generate a valid SAP master password
* `99_delete_sap_cal_service_account.sh` : Delete service account for the SAP Cloud Appliance Library
* `ZZ_debug.sh`                          : For debugging only

## Create Account

Create a service account and key for SAP CAL:

```shell
bash 01_create_sap_cal_service_account.sh
```

Upload `private_key_sa-sap-cal_JSON.json`:

![Screenshot: SAP CAL](../images/sap_cal_json.jpg)

## Create Instance

Enable advanced mode:

![Screenshot: SAP CAL Instance](../images/cal-1-advanced.png)

Show details and generate a valid SAP master password:

```shell
bash 02_details_for_sap_cal.sh
```

Example:

![Screenshot: Instance details for SAP CAL](../images/cal-2-details.png)

Enter details:

![Screenshot: SAP CAL Instance](../images/cal-3-enter-details.png)

Disable extra Windows virtual machine (we have our own Windows jump host. Please see [05_windows](../05_windows/)):

![Screenshot: Disable Windows](../images/cal-4-disable-windows.png)

Keep clicking until all is completed 😀

## Connect

Get IP:

![Screenshot: SAP CAL IP](../images/cal-5-vm-ip.png)

Get SAP system data:

![Screenshot: SAP CAL system data](../images/cal-6-passwords.png)

Enter this information in your SAP logon and connect to the SAP system:

![Screenshot: SAP Logon](../images/cal-7-sapgui-s4h.png)

Have fun:

![Screenshot: SAP GUI ST06](../images/cal-8-s4h-st06.png)