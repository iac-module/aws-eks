terraform {
  required_version = "~> 1.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
  }
  provider_meta "aws" {
    user_agent = [
      "github.com/terraform-aws-modules/terraform-aws-eks"
    ]
  }
}
