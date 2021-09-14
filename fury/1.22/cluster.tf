data "aws_region" "current" {}

module "fury" {
  source = "../../modules/aws-k8s-conformance"

  region = data.aws_region.current.name

  cluster_name    = "fury"
  cluster_version = "1.22.0"

  worker_instance_type = "m4.xlarge"
  master_instance_type = "m4.xlarge"
  worker_count = 3

  public_subnet_id  = "subnet-0e9dfc31980df9a85"
  private_subnet_id = "subnet-0c34697381d7c45a4"
  pod_network_cidr  = "10.0.0.0/16"

  cgroupdriver = "systemd"
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
  value       = "cd 1.22 && ${module.fury.ssh_command_help}"
}

output "worker_private_ip" {
  description = "Worker nodes private ip list"
  value       = module.fury.worker_private_ip
}

output "kubeconfig" {
  value = module.fury.kubeconfig
}
