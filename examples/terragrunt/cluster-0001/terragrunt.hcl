include {
  path = find_in_parent_folders("root.hcl")
}
iam_role = local.account_vars.iam_role

terraform {
  source = "git::https://github.com/iac-module/aws-eks.git//?ref=zzzzz" #v1.3.1
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc/main")
}

locals {
  common_tags  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.aws_region
  name         = basename(get_terragrunt_dir())
  cluster_name = "${local.account_vars.locals.env_name}-${local.name}"
}

inputs = {
  name               = local.cluster_name
  kubernetes_version = "1.33"

  endpoint_public_access = true
  endpoint_public_access_cidrs = [
    "0.0.0.0/0" # Allow all
  ]
  enabled_log_types = [
    "audit"
  ]
  upgrade_policy = {
    support_type = "STANDARD"
  }
  addons = {
    aws-ebs-csi-driver = {
      addon_version = "v1.46.0-eksbuild.1"
    }
    coredns = {
      addon_version        = "v1.12.2-eksbuild.4"
      configuration_values = jsonencode({})
      #   computeType = "fargate"
      #   podLabels   = { fargate_ready = "true" }
      # })
    }
    kube-proxy = {
      addon_version = "v1.33.0-eksbuild.2"
    }
    vpc-cni = {
      addon_version = "v1.20.0-eksbuild.1"
    }
    eks-pod-identity-agent = {
      addon_version = "v1.3.8-eksbuild.2"
    }
  }
  vpc_id                                                = dependency.vpc.outputs.vpc_id
  subnet_ids                                            = dependency.vpc.outputs.private_subnets
  control_plane_subnet_ids                              = dependency.vpc.outputs.private_subnets
  node_security_group_tags                              = { "karpenter.sh/discovery" = local.cluster_name }
  eks_cluster_primary_security_group_custom_rule_create = true
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

  eks_managed_node_groups = {
    karpenter = {
      ami_type       = "BOTTLEROCKET_ARM_64"
      instance_types = ["t4g.small"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
      taints = {
        purpose = {
          key    = "purpose"
          value  = "karpenter"
          effect = "NO_SCHEDULE"
        }
        lifecycle = {
          key    = "lifecycle"
          value  = "on-demand"
          effect = "NO_SCHEDULE"
        }
        arch = {
          key    = "arch"
          value  = "arm64"
          effect = "NO_SCHEDULE"
        }
      }
      labels = {
        # Used to ensure Karpenter runs on nodes that it does not manage
        "purpose"                 = "karpenter"
        "lifecycle"               = "on-demand"
        "arch"                    = "arm64"
        "karpenter.sh/controller" = "true"
      }
    }
  }


  fargate_profiles = {
    kube-system = {
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
      selectors = [
        {
          namespace = "argo"
          labels = {
            fargate_ready = "true"
          }
        }
      ]
    }
    # karpenter = {
    #   selectors = [
    #     {
    #       namespace = "karpenter"
    #       labels = {
    #         fargate_ready = "true"
    #       }
    #     }
    #   ]
    # }
  }
  access_entries = {
    # One access entry with a policy associated
    devops = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::${local.account_vars.locals.aws_account_id}:role/YYYYYYY"
      policy_associations = {
        1 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
    terraform-role = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::${local.account_vars.locals.aws_account_id}:role/terraform-role"
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
    create_pod_identity_association = true
    node_iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore   = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ebs_csi_role                   = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
      AmazonEKSVPCResourceController = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    }
    queue_managed_sse_enabled = false
    queue_kms_master_key_id   = "alias/aws/sqs"

    tags = local.common_tags.locals.common_tags
  }
  aws_lb_resources = {
    create = true
    tags   = local.common_tags.locals.common_tags
  }
  argocd = {
    repo_credentials_configuration = {
      type                           = "github_app"
      githubAppID                    = "XXXX"
      githubAppInstallationID        = "YYYYY"
      repo_url                       = "https://github.com/${local.account_vars.locals.gh_organization}/devops-k8s-core.git"
      param_store_repository_ssk_key = "/${local.account_vars.locals.owner}/${local.account_vars.locals.env_name}/infra/shared/secret/K8S-INFRA-DeployKey"
    }
    app_of_apps = {
      name = local.cluster_name
      repository = {
        url            = "https://github.com/${local.account_vars.locals.gh_organization}/devops-k8s-core.git"
        targetRevision = "master"
        path           = "${local.account_vars.locals.env_name}"
      }
    }
  }
}
