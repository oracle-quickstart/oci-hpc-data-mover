resource "oci_core_volume" "bastion_volume" { 
  count = var.bastion_block ? 1 : 0
  availability_domain = var.bastion_ad
  compartment_id = var.targetCompartment
  display_name = "${local.cluster_name}-bastion-volume"
  
  size_in_gbs = var.bastion_block_volume_size
  vpus_per_gb = split(".", var.bastion_block_volume_performance)[0]
} 

resource "oci_core_volume_attachment" "bastion_volume_attachment" { 
  count = var.bastion_block ? 1 : 0 
  attachment_type = "iscsi"
  volume_id       = oci_core_volume.bastion_volume[0].id
  instance_id     = oci_core_instance.bastion.id
  display_name    = "${local.cluster_name}-bastion-volume-attachment"
  device          = "/dev/oracleoci/oraclevdb"
} 

resource "oci_core_instance" "bastion" {
  depends_on          = [oci_core_subnet.public-subnet]
  availability_domain = var.bastion_ad
  compartment_id      = var.targetCompartment
  shape               = var.bastion_shape

  dynamic "shape_config" {
    for_each = local.is_bastion_flex_shape
      content {
        ocpus = shape_config.value
        memory_in_gbs = var.bastion_custom_memory ? var.bastion_memory : 16 * shape_config.value
      }
  }
  agent_config {
    is_management_disabled = true
    }
  display_name        = "${local.cluster_name}-bastion"

  freeform_tags = {
    "cluster_name" = "local.cluster_name"
    "parent_cluster" = "local.cluster_name"
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_key}\n${tls_private_key.ssh.public_key_openssh}"
    user_data           = base64encode(data.template_file.bastion_config.rendered)
  }
  source_details {
    source_id   = var.use_standard_image ? data.oci_core_images.linux.images.0.id : local.custom_bastion_image_ocid
    boot_volume_size_in_gbs = var.bastion_boot_volume_size
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = local.bastion_subnet_id
  }
} 

resource "null_resource" "bastion" { 
  depends_on = [oci_core_instance.bastion, oci_core_volume_attachment.bastion_volume_attachment ] 
  triggers = { 
    bastion = oci_core_instance.bastion.id
  } 

  provisioner "file" {
    source        = "playbooks"
    destination   = "/home/${var.bastion_username}/"
    connection {
      host        = oci_core_instance.bastion.public_ip
      type        = "ssh"
      user        = var.bastion_username
      private_key = tls_private_key.ssh.private_key_pem
    }
  }


  provisioner "file" { 
    content        = templatefile("${path.module}/configure.tpl", { 
      configure = var.configure
    })
    destination   = "/tmp/configure.conf"
    connection {
      host        = oci_core_instance.bastion.public_ip
      type        = "ssh"
      user        = var.bastion_username
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "file" {
    content     = tls_private_key.ssh.private_key_pem
    destination = "/home/${var.bastion_username}/.ssh/cluster.key"
    connection {
      host        = oci_core_instance.bastion.public_ip
      type        = "ssh"
      user        = var.bastion_username
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "file" {
    source      = "bastion.sh"
    destination = "/tmp/bastion.sh"
    connection {
      host        = oci_core_instance.bastion.public_ip
      type        = "ssh"
      user        = var.bastion_username
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "file" {
    source      = "configure.sh"
    destination = "/tmp/configure.sh"
    connection {
      host        = oci_core_instance.bastion.public_ip
      type        = "ssh"
      user        = var.bastion_username
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/${var.bastion_username}/.ssh/cluster.key",
      "chmod 600 /home/${var.bastion_username}/.ssh/id_rsa",
      "chmod a+x /tmp/bastion.sh",
      "/tmp/bastion.sh"
      ]
    connection {
      host        = oci_core_instance.bastion.public_ip
      type        = "ssh"
      user        = var.bastion_username
      private_key = tls_private_key.ssh.private_key_pem
    }
  }
}
  
resource "null_resource" "cluster" { 
  depends_on = [null_resource.bastion, oci_core_instance_pool.instance_pool, oci_core_instance.bastion, oci_core_volume_attachment.bastion_volume_attachment ] 
  triggers = { 
    cluster_instances = join(", ", local.cluster_instances_names)
  } 

  provisioner "file" {
    content        = templatefile("${path.module}/inventory.tpl", {  
      bastion_name = oci_core_instance.bastion.display_name, 
      bastion_ip = oci_core_instance.bastion.private_ip, 
      compute = var.node_count > 0 ? zipmap(local.cluster_instances_names, local.cluster_instances_ips) : zipmap([],[])
      public_subnet = data.oci_core_subnet.public_subnet.cidr_block, 
      private_subnet = data.oci_core_subnet.private_subnet.cidr_block, 
      nfs = var.node_count > 0 ? local.cluster_instances_names[0] : "",
      home_nfs = var.home_nfs,
      scratch_nfs = var.use_scratch_nfs && var.node_count > 0,
      cluster_nfs = var.use_cluster_nfs,
      cluster_nfs_path = var.cluster_nfs_path,
      scratch_nfs_path = var.scratch_nfs_path,
      add_nfs = var.add_nfs,
      nfs_target_path = var.nfs_target_path,
      nfs_source_IP = local.nfs_source_IP,
      nfs_source_path = var.nfs_source_path,
      nfs_options = var.nfs_options,
      cluster_network = var.cluster_network,
      slurm = var.slurm,
      bastion_block = var.bastion_block,
      scratch_nfs_type = local.scratch_nfs_type,
      bastion_mount_ip = local.bastion_mount_ip,
      cluster_mount_ip = local.mount_ip,
      cluster_name = local.cluster_name,
      shape = var.instance_pool_shape,
      instance_pool_ocpus = var.instance_pool_ocpus,
      monitoring = var.monitoring,
      bastion_username = var.bastion_username
      compute_username = var.compute_username
      destination_fs_server_ip = var.destination_fs_server_ip
      destination_fs_directory_to_sync = var.destination_fs_directory_to_sync
      destination_fs_server_user = var.destination_fs_server_user
      source_fs_server_ip = var.source_fs_server_ip
      source_fs_server_exported_path = var.source_fs_server_exported_path
      source_fs_local_mount_path = var.source_fs_local_mount_path
      source_fs_directory_to_sync = var.source_fs_directory_to_sync
      source_fs_options = var.source_fs_options

      })

    destination   = "/home/${var.bastion_username}/playbooks/inventory"
    connection {
      host        = oci_core_instance.bastion.public_ip
      type        = "ssh"
      user        = var.bastion_username
      private_key = tls_private_key.ssh.private_key_pem
    }
  }


  provisioner "file" {
    content     = var.node_count > 0 ? join("\n",local.cluster_instances_ips) : "\n"
    destination = "/tmp/hosts"
    connection {
      host        = oci_core_instance.bastion.public_ip
      type        = "ssh"
      user        = var.bastion_username
      private_key = tls_private_key.ssh.private_key_pem
    }
  }





  provisioner "remote-exec" {
    inline = [
      "chmod a+x /tmp/configure.sh",
      "echo ${var.configure} > /tmp/configure.conf",
      "/tmp/configure.sh"
      ]
    connection {
      host        = oci_core_instance.bastion.public_ip
      type        = "ssh"
      user        = var.bastion_username
      private_key = tls_private_key.ssh.private_key_pem
    }
  }
}
