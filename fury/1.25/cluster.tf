data "aws_region" "current" {}

module "fury" {
  source = "../../modules/aws-k8s-conformance"

  region = data.aws_region.current.name

  cluster_name    = "fury"
  cluster_version = "1.25.6"

  worker_instance_type = "m5.2xlarge"
  master_instance_type = "m5.xlarge"
  worker_count = 3

  public_subnet_id  = "subnet-007bd514ac9ac034f"
  private_subnet_id = "subnet-0302825f049261249"
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
  value       = "cd 1.25 && ${module.fury.ssh_command_help}"
}

output "worker_private_ip" {
  description = "Worker nodes private ip list"
  value       = module.fury.worker_private_ip
}

output "kubeconfig" {
  value = module.fury.kubeconfig
}
