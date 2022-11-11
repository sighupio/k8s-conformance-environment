variable "public_subnet_id" {
  type        = string
  description = "Public subnet ID where control-plane will run"
}

variable "private_subnet_id" {
  type        = string
  description = "Private subnet ID where worker nodes will run"
}

variable "region" {
  type        = string
  description = "AWS Region where cluster will run"
}

variable "cluster_name" {
  type        = string
  description = "Unique identifier of the cluster. Used as system user to log into the instances"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version to deploy"
}

variable "trusted_cidrs" {
  type        = list
  description = "List of allowed cidrs to access the control-plane/cluster"
  default     = ["0.0.0.0/0"]
}

variable "master_instance_type" {
  type        = string
  description = "Instance type used to run Kubernetes control-plane. Choose one: m5.large, m5.xlarge, m5.2xlarge, m5.4xlarge"
  default     = "m5.large"
}

variable "worker_instance_type" {
  type        = string
  description = "Instance type used to run Kubernetes worker. Choose one: m5.large, m5.xlarge, m5.2xlarge, m5.4xlarge"
  default     = "m5.xlarge"
}

variable "worker_count" {
  type        = number
  description = "Number of workers nodes to deploy"
  default     = 2
}

variable "pod_network_cidr" {
  type        = string
  description = "Specify range of IP addresses for the pod network. Default to calico default value"
  default     = "192.168.0.0/16"
}

locals {
  # https://cloud-images.ubuntu.com/locator/ec2/
  # filter: 20.04 LTS eu-
  ubuntu_amis = {
    "eu-west-1" : "ami-04e2e94de097d3986"
  }
  # https://aws.amazon.com/ec2/pricing/on-demand/
  # Just split by ~2 the ondemenad price.
  sport_prices = {
    "m4.large" : "0.07"
    "m4.xlarge" : "0.12"
    "m5.large" : "0.07"
    "t3.large" : "0.10"
    "m5.xlarge" : "0.12"
    "t3.xlarge" : "0.16"
    "m5.2xlarge" : "0.20"
    "m5.4xlarge" : "0.40"
    "m5a.4xlarge" : "0.45"
  }
}
