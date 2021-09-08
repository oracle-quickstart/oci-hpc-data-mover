# OCI HPC Data Mover Stack 

## Terminology
The OCI HPC Data Mover can be used to migrate/copy/sync/replicate files from one POSIX file system to another POSiX file system.  This document will use the term "Data Move" to represent "migrate/copy/sync/replicate files from one POSIX file system to another POSiX file system".  

## Architecture

## Use Cases

- Cross Region Data Move 
- Cross Availability Domain (AD) Data Move 
- Same Availability Domain (AD) Data Move 
- On-Premise to OCI Data Move* 
- OCI to On-Premise Data Move
- Multi-Cloud Data Move*

* Reach out to OCI HPC Storage Team (pinkesh.valdria@oracle.com) 


### Cross Region Data Move 

### Cross Availability Domain (AD) Data Move 

### Same Availability Domain (AD) Data Move 



## Pre-requisites 

1. Policies and Group to manage resources, see below
2. VCN Peering - Local or Remote 
3. FastConnect or IP-Sec VPN for On-Premise to OCI or vice-versa
4. Shared file system for Data Mover Tool files (very small footprint). You can use OCI FSS. If you have exising FSS file system in same subnet, you can use that or create a new FSS file system as part of the Data Mover Stack deployment (note: when cluster is terminated, it will terminate the FSS file system also, if it was created using this stack.


## Deploy

### Stack to create the OCI HPC Data Mover cluster 

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-quickstart/oci-hpc-data-mover/releases/download/v1.0.0/oci-hpc-data-mover.zip)

### Marketplace listing to create the OCI HPC Data Mover cluster 

### Manual deployment from github - Advanced Users Only

```
git clone https://github.com/oracle-quickstart/oci-hpc-data-mover.git

zip -r oci-hpc-data-mover.zip oci-hpc-data-mover -x '*.terraform*' -x '*oci-hpc-data-mover.xcworkspace*' -x '*terraform.tfstate*' -x '*.tfvars*' -x '.gitignore' -x '*.git*' -x '*.git-backup*'

Use the zip file to deploy from OCI Web Console using Stacks

```

## Policies to deploy the stack: 
```
allow service compute_management to use tag-namespace in tenancy
allow service compute_management to manage compute-management-family in tenancy
allow service compute_management to read app-catalog-listing in tenancy
allow group groupname to manage all-resources in compartment compartmentName
```



## Monitoring

Grafana is deployed on Bastion node and can be accessed via  http://<bastion-public-ip>:3000/
Make sure port 3000 is open on your public subnet security list for TCP ingress.

### Total Bandwidth Dashboard 

Origin_prom=None
JOB=Prometheus
Host=<select all worker nodes>
Instance=<select all worker nodes>
NIC=<select NIC>

Graph shows aggregate n/w bandwidth transmit Gbps from all worker nodes (to migration Target/Destination node) as well as for each individual worker node. 





## Design Considerations
1. Data Mover tool should be deployed in an AD which has the Source file system, so its a local mount and not a remote mount over WAN for better performance
2. For On-Premise to OCI data move,   preferred recommendation is to run the worker nodes in an on-premise environment.  If that isn't possible, then it can be ran in nearest OCI region. 







