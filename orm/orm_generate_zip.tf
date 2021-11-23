variable "save_to" {
    default = ""
}

data "archive_file" "generate_zip" {
  type        = "zip"
  output_path = (var.save_to != "" ? "${var.save_to}/oci_hpc_data_mover.zip" : "${path.module}/dist/oci_hpc_data_mover.zip")
  source_dir = "../"
excludes    = [".gitignore" , "terraform.tfstate", "terraform.tfvars.template", "terraform.tfvars", "terraform.tfvars.1", "provider.tf", ".terraform", "images" , "orm" , ".git" , "localonly" , "terraform.tfstate.backup" , "oci-hpc-data-mover.xcworkspace" ,  "local_only" ] 
}
