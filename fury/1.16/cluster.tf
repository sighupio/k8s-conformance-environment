data "aws_region" "current" {}

module "fury" {
  source = "../../modules/aws-k8s-conformance"

  region = data.aws_region.current.name

  cluster_name    = "fury"
  cluster_version = "1.16.2"

  public_subnet_id  = "subnet-01afb30699efd2ddc"
  private_subnet_id = "subnet-00bb7ff43751d9470"
  pod_network_cidr  = "172.16.0.0/16"

}

output "tls_private_key" {
  sensitive   = true
  description = "Private RSA Key to log into the control plane node"
  value       = module.fury.tls_private_key
}

output "master_public_ip" {
  description = "Public IP where control plane is exposed"
  value       = module.fury.master_public_ip
}

output "ssh_command_help" {
  description = "Long command to ssh the control plane"
  value       = "cd 1.16 && ${module.fury.ssh_command_help}"
}

output "worker_private_ip" {
  description = "Worker nodes private ip list"
  value       = module.fury.worker_private_ip
}
