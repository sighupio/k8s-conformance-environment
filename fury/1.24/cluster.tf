data "aws_region" "current" {}

module "fury" {
  source = "../../modules/aws-k8s-conformance"

  region = data.aws_region.current.name

  cluster_name    = "fury"
  cluster_version = "1.24.7"

  worker_instance_type = "t3.large"
  master_instance_type = "t3.large"
  worker_count = 3

  public_subnet_id  = "subnet-02bab6ece35c25109"
  private_subnet_id = "subnet-08da9c7869d65c505"
  pod_network_cidr  = "10.200.0.0/16"

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
  value       = "cd 1.24 && ${module.fury.ssh_command_help}"
}

output "worker_private_ip" {
  description = "Worker nodes private ip list"
  value       = module.fury.worker_private_ip
}

output "kubeconfig" {
  value = module.fury.kubeconfig
}
