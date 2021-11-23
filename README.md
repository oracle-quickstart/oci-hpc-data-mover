# OCI HPC Data Mover Stack to create a cluster of nodes to migration data. 


## Terminology
The OCI HPC Data Mover can be used to migrate/copy/sync/replicate data. This document will use the term "Data Move/Migrate" to represent "migrate/copy/sync/replicate data.

## OCI HPC Data Mover 

All-in-One File System and Object Storage Data Migration Cluster to migrate data between POSIX and Object Storage system.  Source and Destination for migration can be on-premise, OCI Cloud, Other Clouds (AWS, GCP, Azure, etc). Within OCI, it supports Cross Region, Cross AD, Same AD data migrations.


### Types of Migration Supported
OCI HPC Data Mover Tool can be used to migrate data for following scenarios. It supports 4 types of migration.  Source or Destination can be on-premise, OCI or another cloud provider (file system or object storage).

- POSIX to POSIX file system
- Object Storage to Object Storage
- POSIX to Object Storage
- Object Storage to POSIX 
 

It's designed to speed up migration by using mutiple nodes and multiple threads per node to fully utilize network bandwidth.  It can scale to n worker nodes.  Once the migration is done, the cluster can be terminated.  It can also be used for recurring sync between two systems using a cron job.  

This solution deploys a cluster of n worker nodes, configures them for passwordless ssh, mounts file system (if required),  configures migration tools with customer credentials, generates helper scripts preconfigured with values as per customer needs to run migration tools.  If fpsync tool is used, then it will provision and mount a shared NFS file system to share list of files to sync and log files.    

### Migration Tools supported by OCI HPC Data Mover
Currenty, this solution supports the following migration tools.  Some of it are widely used open source tools and some are Oracle developed. 

- Open source fpsync / fpart  
- OCI parallel data migration tools like parallel tar (partar) and parallel copy (parcp)
- OCI CLI tool 
- rclone
- s5cmd

We plan to add more migration tools, with the goal to make it a one-stop shop for data migration and customer can pick any tool based on their migration needs. 


**Which tool should i use for my use case?**
We have some guidelines, see section "Compare Migration Tools" for more details. 


This solution also include Grafana to monitor worker nodes, including total bandwidth used by all worker nodes for moving data.


### Compare Migration Tools 
This is not a comprehensive list for comparison.  This is a subset of how we envision customers might use.  We welcome feedback to update these documentation as well as the tool.  

#### POSIX Tools 
| Features | fpsync | OCI parallel transfer tool | Comments |
| --- | --- | --- | --- |
| POSIX to POSIX | Y | Y | Any POSIX compliany file system.  fpsync+fpart includes built-in support for multiple worker/transfer nodes to do transfer in parallel and reduce migration time.  With OCI parallel transfer tools, you can still use multiple worker/transfer nodes and copy different non-overlapping directory on each node. |
| NFS to POSIX | Y | Y | same as above |
| POSIX to NFS | Y | Y | same as above |
| PFS to POSIX | Y | Y | same as above. PFS stands for Parallel File Systems like IBM Spectrum Scale (aka: GPFS), Lustre, BeeGFS, BeeOND, Quobyte, etc. |
| POSIX to PFS | Y | Y | same as above |


#### Object Storage Tools 
| Features | rclone | OCI CLI sync or Bulk Copy | s5cmd | Comments |
| --- | --- | --- | --- | --- |
| Sync/Copy from one Cloud provider to another | Y | N | N | - |
| Cross region - Sync/Copy in OCI | Y | Y | N | - |
| Same region - Sync/Copy in OCI| Y | Y  | Y | - |
| Object Storage as Source | Y | Y | Y | - |
| Object Storage as Destination | Y | Y | Y | - |
| Azure Blob as Source | Y | N | N | - |
| Google Cloud Storage as Source | Y | N | Y | - |
| AWS S3 as Source | Y | N | Y | - |
| Other S3 compatible Storage as Source | Y | N | Y | - |



## Architecture



## Pre-requisites 

1. Make sure Policies and  Group are created to manage resources, see below

- Create Group:  Group-X with users who should be allowed to create resources in the compartment you plan to use 
- Create policy 
```
allow service compute_management to use tag-namespace in tenancy
allow service compute_management to manage compute-management-family in tenancy
allow service compute_management to read app-catalog-listing in tenancy
allow group Group-X to manage all-resources in compartment compartmentName
```
2. Only for fpsync based POSIX-2-POSIX migration - A Shared file system for Data Mover Tool files (very small footprint) is required.  A few options:

- You can use OCI FSS file system. If you have existing FSS file system in same subnet which you plan to use for worker nodes, you can use that or
- Create a new FSS file system outside of this deployment and provide details to mount it on the worker nodes during Data Mover deployment
- Ask Data Mover Stack deployment to create a new FSS file system during deployment. (note: when Data Mover cluster is terminated, it will terminate the FSS file system also, if it was created using this stack).
- Use an existing custom NFSv3 file system you have deployed on OCI
- For NFS Source file system which requires mounting, make sure the worker nodes private subnet CIDR is permitted ro access in /etc/exports on your NFS server 

3. Create VCN Peering - Local or Remote, if its needed for your migration needs

4. FastConnect or IP-Sec VPN for On-Premise to OCI or vice-versa or Cloud to Cloud, if its needed for your migration needs

5. For NFS to POSIX or NFS to Object Storage, the Source NFS should be ro mounted on worker nodes and hence need NFS server /etc/exports to permit NFS mount from worker nodes private subnet CIDR range.

6. For Object Storage to NFS, the Destination NFS should be rw mounted on worker nodes and hence need NFS server /etc/exports to permit NFS mount from worker nodes private subnet CIDR range.



## Deploy

### Marketplace listing to create the OCI HPC Data Mover cluster 

[!OCI-HPC-Data-Mover-Cluster-Marketplace-Listing](https://cloudmarketplace.oracle.com/marketplace/en_US/listing/108840961)

### ORM Stack to create the OCI HPC Data Mover cluster 

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-quickstart/oci-hpc-data-mover/releases/download/v2.0.0/oci-hpc-data-mover.zip)


## Monitoring

Grafana is deployed on Bastion node and can be accessed via  http://<bastion-public-ip>:3000/ .  Make sure port 3000 is open on your public subnet security list for TCP ingress. Default username/password is **admin/admin**.

### Total Bandwidth Dashboard 
Set these values on dashboard: 
 
```
- Origin_prom=None
- JOB=Prometheus
- Host=<select all worker nodes>
- Instance=<select all worker nodes>
- NIC=<select NIC>
```

Graph shows aggregate n/w bandwidth transmit Gbps from all worker nodes (to migration Target/Destination node) as well as for each individual worker node. 



## Post Deployment Steps 


Common steps, irrespective of which migration tool is used. 

```
# Login to bastion node: 
pvaldria-mac:~ pvaldria$ ssh -i ~/.ssh/gg_id_rsa opc@132.145.150.129

# Worker nodes have friendly hostname: hpc-node-n
[opc@alert-feline-bastion ~]$ ssh hpc-node-1

# There is a script in /home/opc to generate the migrate commands (it will not do migration yet) for all tools you selected during deployment.
[opc@inst-zz23o-alert-feline ~]$ ./generate_migrate_command.sh

# Each migrate command is in a text file
[opc@inst-zz23o-alert-feline ~]$ ls  -l *.txt 
-rw-rw-r--. 1 opc  opc   584 Nov 22 12:39 fpsync_migrate_command_to_run.txt
-rw-rw-r--. 1 opc  opc   652 Nov 22 12:39 oci_partar_migrate_command_to_run.txt

# Example command for fpsync.  Check the source and destination directories, server ip, etc.  

[opc@inst-zz23o-alert-feline ~]$ cat fpsync_migrate_command_to_run.txt
# NOTE: Should be ran on one node only (eg: hpc-node-1) and it will spawn process on all worker nodes by itself. 
# time fpsync  -w opc@hpc-node-1  -w opc@hpc-node-2   -d /mnt/iad-ad-3-fss/fpsync_prototype  -t  /mnt/iad-ad-3-fss/fpsync_prototype/tmp -vvvv -n 30 -f 900  -o " -lptgoD -v --numeric-ids  -e \\\"  ssh -i /home/opc/.ssh/id_rsa   \\\" "   /mnt/iad-ad-3-fss/linux_src_code opc@127.0.0.1:/mnt/iad-ad-3-fss/dst_dir/

```


## Post Deploy Configuration for Specific Tool 

### fpsync

- The destination server needs to be configured to allow ssh access from the worker nodes (no password prompts). To do so, copy the content of */home/opc/.ssh/id_rsa.pub* from a worker node to  */home/opc/.ssh/authorized_keys* file on the destination server.  

- Update the *-n jobs -f files -s size * parameter to suite your needs.  Run man fpsync to see explaination of all options. 

- Online documentation: https://github.com/martymac/fpart/blob/master/tools/fpsync or  http://www.fpart.org/fpsync/ 

  
### OCI Parallel File Transfer tool
There is no post deploy configuration needed.  Refer to command file:  */home/opc/oci_partar_migrate_command_to_run.txt* generated on the node and below documentation.  

- Online documentation: 
  - https://docs.oracle.com/en-us/iaas/Content/File/Tasks/using_file_storage_parallel_tools.htm
  - https://blogs.oracle.com/cloud-infrastructure/post/announcing-parallel-file-tools-for-file-storage 


### rclone 
There is no post deploy configuration needed.  Refer to command file:  */home/opc/rclone_migrate_command_to_run.txt* generated on the node and below documentation.  

- Online documentation:  https://rclone.org/commands/rclone_sync/ 

### s5cmd 
There is no post deploy configuration needed.  Refer to command file:  */home/opc/s5cmd_migrate_command_to_run.txt* generated on the node and below documentation.  

- Online documentation:  https://github.com/peak/s5cmd

### oci-cli
Refer to command file:  */home/opc/oci_cli_migrate_command_to_run.txt* generated on the node, post-deploy steps and documentation below. 

- Worker nodes needs IAM permissions to access OCI Object Storage.  There are many ways to configure OCI-CLI with credentials (not in scope for this document).  One of the way is to authorize these worker nodes (Instances) to invoke OCI services. See below for documentation:
  -  https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/callingservicesfrominstances.htm 
  -  https://blogs.oracle.com/developers/post/accessing-the-oracle-cloud-infrastructure-api-using-instance-principals 
- Sample Dynamic Group
  ```
  ANY {instance.compartment.id = 'ocid1.compartment.oc1..aaaaaaaaavf4luemfaxzxurazykuycjiv53zazv6ath5gwbki5dykjnxyawq'}    
  ```
- Sample Policy. Create policy in root compartment. Assume you are using compartment C which is a child of root-compartment:A:B. 
  ```
  allow dynamic-group pinkesh_instance_principal to manage object-family in compartment A:B:C    
  ```
- Documentation
  - sync command - See documentation for all options: https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.0.2/oci_cli_docs/cmdref/os/object/sync.html#examples   
  - bulk copy - Use Bulk Copy for Cross region or same region - copy (not sync) of same cloud provider. See documentation for all options: https://github.com/oracle/oci-python-sdk/tree/master/examples/object_storage








