output "bastion" {
  value = oci_core_instance.bastion.public_ip
}

output "private_ips" {
  value = join(" ", local.cluster_instances_ips)
}

output "generated_ssh_public_key_to_add_to_destination_node" {
  value = tls_private_key.ssh.public_key_openssh
}
