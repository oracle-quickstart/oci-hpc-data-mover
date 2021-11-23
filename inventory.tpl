[bastion]
${bastion_name} ansible_host=${bastion_ip} ansible_user=${bastion_username} role=bastion
[compute]
%{ for host, ip in compute ~}
${host} ansible_host=${ip} ansible_user=${compute_username} role=compute
%{ endfor ~}
[all:children]
bastion
compute
[all:vars]
ansible_connection=ssh
rdma_network=192.168.168.0
rdma_netmask=255.255.252.0
public_subnet=${public_subnet} 
private_subnet=${private_subnet}
cluster_name = ${cluster_name}
shape=${shape}
add_nfs=${add_nfs}
nfs_target_path=${nfs_target_path}
nfs_source_IP=${nfs_source_IP}
nfs_source_path=${nfs_source_path}
nfs_options=${nfs_options}
instance_pool_ocpus=${instance_pool_ocpus}
monitoring=${monitoring}
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

destination_fs_server_ip=${destination_fs_server_ip}
destination_fs_server_exported_path=${destination_fs_server_exported_path}
destination_fs_local_mount_path=${destination_fs_local_mount_path}
destination_fs_options=${destination_fs_options}
# Outside of this tool, give opc user permission to write destination fs or use user account which has permission.
destination_fs_directory_to_sync=${destination_fs_directory_to_sync}


prereq_complete=${prereq_complete}
posix_2_posix=${posix_2_posix}
posix_2_os=${posix_2_os}
os_2_os=${os_2_os}
os_2_posix=${os_2_posix}

fpsync=${fpsync}
oci_parallel_transfer_tools=${oci_parallel_transfer_tools}
posix_all_tools=${posix_all_tools}
rclone=${rclone}
s5cmd=${s5cmd}
oci_cli=${oci_cli}
os_all_tools=${os_all_tools}

src_os_type=${src_os_type}
src_access_key_id=${src_access_key_id}
src_secret_access_key=${src_secret_access_key}
src_region=${src_region}
src_endpoint=${src_endpoint}
src_bucket_name=${src_bucket_name}

destination_os_type=${destination_os_type}
destination_access_key_id=${destination_access_key_id}
destination_secret_access_key=${destination_secret_access_key}
destination_region=${destination_region}
destination_endpoint=${destination_endpoint}
destination_bucket_name=${destination_bucket_name}

      
