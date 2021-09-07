# OCI HPC Data Mover Stack to create a cluster of nodes to migration file system data. 

## Terminology
The OCI HPC Data Mover can be used to migrate/copy/sync/replicate files from one POSIX file system to another POSiX file system.  This document will use the term "Data Move" to represent "migrate/copy/sync/replicate files from one POSIX file system to another POSiX file system".  

## Architecture

## Use Cases

### Cross Region Data Move 

### Cross Availability Domain (AD) Data Move 


## Pre-requisites 

1. Policies and Dynamic Group
2. VCN Peering - Local or Remote 
3. FastConnect or IP-Sec VPN for On-Premise to OCI or vice-versa
4. Shared file system for Data Mover Tool files (very small footprint)

## Deploy


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







