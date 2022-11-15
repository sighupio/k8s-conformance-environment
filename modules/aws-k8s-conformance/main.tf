terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 2.48"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 2.1"
    }
    template = {
      source = "hashicorp/template"
      version = "~> 2.1"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 2.2"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
