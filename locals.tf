locals { 
// display names of instances 
  cluster_instances_ids =  data.oci_core_instance.instance_pool_instances.*.id
  cluster_instances_names =  data.oci_core_instance.instance_pool_instances.*.display_name

  image_ocid = var.unsupported ? var.image_ocid : var.image
  custom_bastion_image_ocid = var.unsupported_bastion ? var.unsupported_bastion_image : var.custom_bastion_image

// ips of the instances
  cluster_instances_ips =  data.oci_core_instance.instance_pool_instances.*.private_ip

// vcn id derived either from created vcn or existing if specified
  vcn_id = var.use_existing_vcn ? var.vcn_id : element(concat(oci_core_vcn.vcn.*.id, [""]), 0)

// subnet id derived either from created subnet or existing if specified
  subnet_id = var.use_existing_vcn ? var.private_subnet_id : element(concat(oci_core_subnet.private-subnet.*.id, [""]), 0)

  nfs_source_IP = var.create_ffs ? element(concat(oci_file_storage_mount_target.FSSMountTarget.*.ip_address, [""]), 0) : var.nfs_source_IP
// subnet id derived either from created subnet or existing if specified
  bastion_subnet_id = var.use_existing_vcn ? var.public_subnet_id : element(concat(oci_core_subnet.public-subnet.*.id, [""]), 0)

  cluster_name = var.use_custom_name ? var.cluster_name : random_pet.name.id


  instance_pool_image = local.image_ocid

  is_bastion_flex_shape = length(regexall(".*VM.*[3-4].*Flex$", var.bastion_shape)) > 0 ? [var.bastion_ocpus]:[]
  is_instance_pool_flex_shape = length(regexall(".*VM.*[3-4].*Flex$", var.instance_pool_shape)) > 0 ? [var.instance_pool_ocpus]:[]

  bastion_mount_ip = var.bastion_block ? element(concat(oci_core_volume_attachment.bastion_volume_attachment.*.ipv4, [""]), 0) : "none"

  scratch_nfs_type = var.scratch_nfs_type_pool 

  iscsi_ip = element(concat(oci_core_volume_attachment.instance_pool_volume_attachment.*.ipv4, [""]), 0)

  mount_ip = local.scratch_nfs_type == "block" ? local.iscsi_ip : "none" 

}
