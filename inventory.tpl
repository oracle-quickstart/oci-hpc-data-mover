[bastion]
${bastion_name} ansible_host=${bastion_ip} ansible_user=${bastion_username} role=bastion
[compute]
%{ for host, ip in compute ~}
${host} ansible_host=${ip} ansible_user=${compute_username} role=compute
%{ endfor ~}
[nfs]
%{ if nfs != "" }
${nfs} ansible_user=${compute_username} role=nfs
%{ endif }
[all:children]
bastion
compute
[all:vars]
ansible_connection=ssh
rdma_network=192.168.168.0
rdma_netmask=255.255.252.0
public_subnet=${public_subnet} 
private_subnet=${private_subnet}
nvme_path=/mnt/localdisk/
scratch_nfs = ${scratch_nfs}
home_nfs = ${home_nfs} 
cluster_nfs = ${cluster_nfs}
cluster_nfs_path = ${cluster_nfs_path}
scratch_nfs_path = ${scratch_nfs_path}
cluster_network = false
slurm = ${slurm}
bastion_block = ${bastion_block}
scratch_nfs_type = ${scratch_nfs_type}
bastion_mount_ip = ${bastion_mount_ip}
cluster_mount_ip = ${cluster_mount_ip}
cluster_name = ${cluster_name}
shape=${shape}
add_nfs=${add_nfs}
nfs_target_path=${nfs_target_path}
nfs_source_IP=${nfs_source_IP}
nfs_source_path=${nfs_source_path}
nfs_options=${nfs_options}
instance_pool_ocpus=${instance_pool_ocpus}
monitoring=${monitoring}
hyperthreading=true
fpsync_shared_fs_dir=${nfs_target_path}/fpsync_prototype
fpsync_shared_fs_tmp_dir=${nfs_target_path}/fpsync_prototype/tmp
destination_fs_server_ssh_private_key_path=/home/opc/.ssh/id_rsa
destination_fs_server_ssh_public_key_path=/home/opc/.ssh/id_rsa.pub
destination_fs_server_ip=${destination_fs_server_ip}
destination_fs_directory_to_sync=${destination_fs_directory_to_sync}
destination_fs_server_user=${destination_fs_server_user}
source_fs_server_ip=${source_fs_server_ip}
source_fs_server_exported_path=${source_fs_server_exported_path}
source_fs_local_mount_path=${source_fs_local_mount_path}
source_fs_options=${source_fs_options}
# Give opc user permission to read src fs
source_fs_directory_to_sync=${source_fs_directory_to_sync}


