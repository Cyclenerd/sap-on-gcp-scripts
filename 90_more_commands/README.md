# Commands

A few commands that will help you with your work.

## Images

List all Google Compute Engine images:
```shell
gcloud compute images list
```

Filter family:
```shell
gcloud compute images list --filter='family ~ debian-10$'
gcloud compute images list --filter='family ~ sles-15$'
gcloud compute images list --filter='family ~ sles-15-sp3-sap$'
gcloud compute images list --filter='family ~ windows-2019$'
```

## Services

[Help](https://cloud.google.com/sdk/gcloud/reference/services/list)

Return the services which the project has enabled:
```shell
gcloud services list --enabled
```

Return the services available to the project to enable.
This list will include any services that the project has already enabled:
```shell
gcloud services list --available
```

Example:
```text
compute.googleapis.com               Compute Engine API
dns.googleapis.com                   Cloud DNS API
logging.googleapis.com               Cloud Logging API
monitoring.googleapis.com            Cloud Monitoring API
storage.googleapis.com               Cloud Storage API
```

## Roles

[Help](https://cloud.google.com/sdk/gcloud/reference/iam/roles/list)

List the roles defined at a parent organization or a project:

```shell
gcloud iam roles list
```

Example:
```yml
---
description: Full control of Compute Engine networking resources.
etag: AA==
name: roles/compute.networkAdmin
stage: GA
title: Compute Network Admin
```

## IAM policy

[Help](https://cloud.google.com/sdk/gcloud/reference/projects/get-iam-policy)

Get IAM policy (roles) for service account:
```shell
gcloud projects get-iam-policy <MY_GCP_PROJECT> \
  --flatten='bindings[].members' \
  --format='table(bindings.role)' \
  --filter=bindings.members:<MY_GCP_SA_ID>
```

Example for service account `sa-sap-cal-demo-1@sap-sandbox-demo-1.iam.gserviceaccount.com` in project `sap-sandbox-demo-1`:
```shell
gcloud projects get-iam-policy sap-sandbox-demo-1 \
  --flatten='bindings[].members' \
  --format='table(bindings.role)' \
  --filter=bindings.members:sa-sap-cal-demo-1@sap-sandbox-demo-1.iam.gserviceaccount.com
```

Example:
```text
ROLE
roles/compute.instanceAdmin.v1
roles/compute.networkAdmin
roles/compute.securityAdmin
```

## Compute Engine disk types

To list all disk types in a project in table form, run:

```shell
gcloud compute disk-types list
```

To list all disk types in the europe-north1-c zone, run:

```shell
gcloud compute disk-types list \
  --filter="zone:europe-north1-c"
```
