# Second Region and Network

Set up a second region and network.

These steps are optional.
Create the second network only if you want to set up failover or cluster.

## Defaults

* Region: `europe-west4`
* Zone: `europe-west4-c`
* Name of the subnetwork: `subnet-europe-west4`
* The IP space allocated to the subnetwork: `192.168.204.0/24`

## Scripts

* `01_create_2nd_network.sh`       : Create a second Virtual Private Cloud (VPC) network in other region
* `02_create_server_in_network.sh` : Create service account and Compute Engine virtual machine instance
