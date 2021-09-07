variable "region" {}
variable "tenancy_ocid" {} 
variable "targetCompartment" {} 
variable "ad" {}
variable "ssh_key" {}
variable "cluster_network" { default = false } 
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
variable "cluster_network_shape" { default = "BM.HPC2.36" }
variable "instance_pool_shape" { default = "VM.Standard2.4" }
variable "node_count" {}
variable "boot_volume_size"  { default = "50" }
variable "use_marketplace_image" { default = false }
variable "image" { default = "ocid1.image.oc1..aaaaaaaa5yxem7wzie34hi5km4qm2t754tsfxrjuefyjivebrxjad4jcj5oa" }
variable "image_ocid" { default = "ocid1.image.oc1..aaaaaaaa5yxem7wzie34hi5km4qm2t754tsfxrjuefyjivebrxjad4jcj5oa" }
variable "unsupported_bastion_image" { default = "" } 
variable "use_cluster_nfs" { default = false}
variable "use_scratch_nfs" { default = false }
variable "cluster_nfs_path" { default = "/nfs/cluster" } 
variable "scratch_nfs_path" { default = "/nfs/scratch" } 
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
variable "slurm" { default = false }
variable "bastion_ocpus" { default = 2}
variable "instance_pool_ocpus" { default = 2} 
variable "instance_pool_memory" { default = 16 }
variable "instance_pool_custom_memory" { default = false }
variable "bastion_memory" { default = 16 }
variable "bastion_custom_memory" { default = false }


variable "bastion_block_volume_performance" { 
/* 
  Allowed values 
  "0.  Lower performance"
  "10. Balanced performance"
  "20. High Performance"
*/ 

default = "10. Balanced performance" 

}

variable "bastion_block" { 
  default = false
} 

variable "bastion_block_volume_size" { 
  default = 1000
}
variable "scratch_nfs_type_cluster" { default = "nvme"} 
variable "scratch_nfs_type_pool" { default = "none" }
variable "cluster_block_volume_size" { default = "1000" }
variable "cluster_block_volume_performance" { default = "10. Balanced performance"}

variable "home_nfs" { default = true } 
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


variable destination_fs_server_ip { default = "172.16.1.3" }
# /mnt/nfsshare/dir1/dir2
variable destination_fs_directory_to_sync { default = "/mnt/nfsshare/dst_linux_src_code/" }
variable destination_fs_server_user { default = "opc" }

variable source_fs_server_ip { default = "10.0.1.21" }
variable source_fs_server_exported_path { default = "/iad-ad-3-fss" }
variable source_fs_local_mount_path { default = "/mnt/iad-ad-3-fss" }
variable source_fs_options { default = "" }
# /path/to/directory/to/sync
variable source_fs_directory_to_sync { default = "/mnt/iad-ad-3-fss/linux_src_code/" }



