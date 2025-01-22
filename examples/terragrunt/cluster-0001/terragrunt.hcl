include {
  path = find_in_parent_folders()
}
iam_role = local.account_vars.iam_role

terraform {
  source = "git::https://github.com/iac-module/aws-eks.git//?ref=v1.2.0"
}

locals {
  common_tags  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.aws_region
  name         = basename(get_terragrunt_dir())
  cluster_name = "${local.account_vars.locals.env}-${local.name}"
}
dependency "vpc" {
  config_path = find_in_parent_folders("core/vpc/main")
}

inputs = {
  cluster_name                  = local.cluster_name
  cluster_version               = "1.31"
  iam_role_permissions_boundary = local.account_vars.locals.permissions_boundary

  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = [
    "1.2.3.4/32", # My IP
  ]
  cluster_enabled_log_types = [
    "audit",
    "api",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  cluster_addons = {
    coredns = {
      addon_version = "v1.11.1-eksbuild.9"
      configuration_values = jsonencode({
        computeType = "fargate"
        podLabels   = { fargate_ready = "true" }
      })
    }
    kube-proxy = {
      addon_version = "v1.30.0-eksbuild.3"
    }
    vpc-cni = {
      addon_version = "v1.18.2-eksbuild.1"
    }
    eks-pod-identity-agent = {
      addon_version = "v1.3.0-eksbuild.1"
    }
  }
  vpc_id                   = dependency.vpc.outputs.vpc_id
  subnet_ids               = dependency.vpc.outputs.private_subnets
  control_plane_subnet_ids = dependency.vpc.outputs.private_subnets

  node_security_group_tags = { "karpenter.sh/discovery" = local.cluster_name }
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t4g.medium", "m6g.medium"]
  }

  cluster_security_group_additional_rules = { # Required when you have workload on faragat
    igress_nodes_ephemeral_ports_tcp = {
      description                = "From node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 0
      to_port                    = 65535
      type                       = "ingress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }
  fargate_profiles = {
    kube-system = {
      iam_role_permissions_boundary = local.account_vars.locals.permissions_boundary
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            fargate_ready = "true"
          }
        }
      ]
    }
    argo = {
      iam_role_permissions_boundary = local.account_vars.locals.permissions_boundary
      selectors = [
        {
          namespace = "argo"
          labels = {
            fargate_ready = "true"
          }
        }
      ]
    }
    karpenter = {
      iam_role_permissions_boundary = local.account_vars.locals.permissions_boundary
      selectors = [
        {
          namespace = "karpenter"
          labels = {
            fargate_ready = "true"
          }
        }
      ]
    }
  }

  access_entries = {
    devops = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::${local.account_vars.locals.aws_account_id}:role/x-devops-role"

      policy_associations = {
        1 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  tags = local.common_tags.locals.common_tags
  karpenter = {
    create                          = true
    enable_pod_identity             = false
    create_pod_identity_association = false
    enable_irsa                     = true

    node_iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
    iam_role_permissions_boundary_arn  = local.account_vars.locals.permissions_boundary
    node_iam_role_permissions_boundary = local.account_vars.locals.permissions_boundary
    queue_managed_sse_enabled          = false
    queue_kms_master_key_id            = "alias/aws/sqs"
    tags = local.common_tags.locals.common_tags
  }
  aws_lb_resources = {
    create                        = true
    role_permissions_boundary_arn = local.account_vars.locals.permissions_boundary
    tags                          = local.common_tags.locals.common_tags


  }
  argocd = {
     repo_credentials_configuration = {
      repo_url                       = "git@github.com:X/Y-K8S-INFRA.git"
      param_store_repository_ssk_key = "/X/Y-0001/infra/shared/secret/K8S-INFRA-DeployKey"
    }
    app_of_apps = {
      name = local.cluster_name
      repository = {
        url            = "git@github.com:X/Y-K8S-INFRA.git"
        targetRevision = "main"
        path           = "dev-0001"
      }
    }
  }
}
