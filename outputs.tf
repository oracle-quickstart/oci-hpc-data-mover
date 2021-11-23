output "bastion" {
  value = oci_core_instance.bastion.public_ip
}

output "private_ips" {
  value = join(" ", local.cluster_instances_ips)
}

output "grafana_url" {
  value = <<END
  http://${oci_core_instance.bastion.public_ip}:3000/
END
}


output "generated_ssh_public_key_to_add_to_destination_node" {
  value = tls_private_key.ssh.public_key_openssh
}

/*
output "next_step_copy_ssh_public_key" {
  value = "Applies only for POSIX-2-POSIX migration: Add the public SSH key to /home/<username>/.ssh/authorized_keys on destination/target file system servers which will be used for migration/sync/copy/replication."
}
*/
