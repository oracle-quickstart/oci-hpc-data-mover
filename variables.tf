variable "region" {}
variable "tenancy_ocid" {} 
variable "targetCompartment" {} 
variable "ad" {}
variable "ssh_key" {}
variable "use_custom_name" {}
variable "cluster_name" { default = "" }
variable "bastion_ad" {}
variable "bastion_shape" {}
variable "use_standard_image" {}
variable "custom_bastion_image" { 
  type = string
  default = "image.ocid" 
}
variable "bastion_boot_volume_size" { default = "50" }
variable "instance_pool_shape" { default = "VM.Standard2.4" }
variable "node_count" {}
variable "boot_volume_size"  { default = "50" }
variable "use_marketplace_image" { default = false }
variable "image" { default = "ocid1.image.oc1..aaaaaaaa5yxem7wzie34hi5km4qm2t754tsfxrjuefyjivebrxjad4jcj5oa" }
variable "image_ocid" { default = "ocid1.image.oc1..aaaaaaaa5yxem7wzie34hi5km4qm2t754tsfxrjuefyjivebrxjad4jcj5oa" }
variable "unsupported_bastion_image" { default = "" } 
variable "vcn_compartment" { default = ""}
variable "vcn_id" { default = ""}
variable "use_existing_vcn" {}
variable "public_subnet_id" { default = ""}
variable "private_subnet_id" { default = ""}
variable "vcn_subnet" { default = "" }
variable "public_subnet" { default = "" }
variable "additional_subnet" { default = "" }
variable "private_subnet" { default = "" }
variable "ssh_cidr" { default = "0.0.0.0/0" }
variable "bastion_ocpus" { default = 2}
variable "instance_pool_ocpus" { default = 2} 
variable "instance_pool_memory" { default = 16 }
variable "instance_pool_custom_memory" { default = false }
variable "bastion_memory" { default = 16 }
variable "bastion_custom_memory" { default = false }




variable "configure" { default = true }


variable "add_nfs" { default = false}
variable "create_ffs" { default = false }
variable "fss_compartment" {default = ""}
variable "fss_ad" {default = ""}
variable "nfs_target_path" { default = "/app"}
variable "nfs_source_IP" { default = ""}
variable "nfs_source_path" { default = "/app"}
variable "nfs_options" {default = ""}
variable "monitoring" { default = true }


variable "use_standard_image_compute" {
  type=bool
  default = true
}


variable "unsupported" { 
  type=bool
  default = false
} 

variable "unsupported_bastion" { 
  type=bool
  default = false 
}

variable "bastion_username" { 
  type = string 
  default = "opc" 
} 

variable "compute_username" { 
  type = string
  default = "opc" 
} 


variable destination_fs_server_ip { default = "10.0.1.21" }
# /mnt/nfsshare/dir1/dir2
variable destination_fs_directory_to_sync { default = "/mnt/nfsshare/dst_linux_src_code/" }
variable destination_fs_server_user { default = "opc" }

variable source_fs_server_ip { default = "10.0.1.21" }
variable source_fs_server_exported_path { default = "/iad-ad-3-fss" }
variable source_fs_local_mount_path { default = "/mnt/iad-ad-3-fss" }
variable source_fs_options { default = "" }
# /path/to/directory/to/sync
variable source_fs_directory_to_sync { default = "/mnt/iad-ad-3-fss/linux_src_code/" }

variable destination_fs_server_exported_path { default = "/iad-ad-3-fss" }
variable destination_fs_local_mount_path { default = "/mnt/iad-ad-3-fss" }
variable destination_fs_options { default = "" }


variable prereq_complete { default = false }
variable posix_2_posix { default = false }
variable posix_2_os { default = false }
variable os_2_os { default = false }
variable os_2_posix { default = false }
      

variable fpsync { default = false }
variable oci_parallel_transfer_tools { default = false }
variable posix_all_tools { default = false }
variable rclone { default = false }
variable s5cmd { default = false }
variable oci_cli { default = false }
variable os_all_tools { default = false }

# access_key_id = Account name for Azure
variable src_os_type { default = "azureblob" }
variable src_access_key_id { default = "ak1234" }
variable src_secret_access_key { default = "abcd" }
variable src_region { default = "us-phoenix-1" }
variable src_endpoint { default = "hpc.compat.objectstorage.us-phoenix-1.oraclecloud.com" }
#bucket name = container name for Azure
variable src_bucket_name { default = "blob-container" }

# access_key_id = Account name for Azure
variable destination_os_type { default = "oci" }
variable destination_access_key_id { default = "ak1234" }
variable destination_secret_access_key { default = "abcd" }
variable destination_region { default = "us-phoenix-1" }
variable destination_endpoint { default = "hpc.compat.objectstorage.us-phoenix-1.oraclecloud.com" }
#bucket name = container name for Azure
variable destination_bucket_name { default = "blob-container" }


