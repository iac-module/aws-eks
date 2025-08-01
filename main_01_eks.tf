module "eks" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=074abf14097264dd13fe3a521cd1d0fe76f6b4ef" #v21.0.4"
  count  = var.create ? 1 : 0

  create                                       = var.create
  prefix_separator                             = var.prefix_separator
  region                                       = var.region
  tags                                         = var.tags
  name                                         = var.name
  kubernetes_version                           = var.kubernetes_version
  enabled_log_types                            = var.enabled_log_types
  force_update_version                         = var.force_update_version
  authentication_mode                          = var.authentication_mode
  compute_config                               = var.compute_config
  upgrade_policy                               = var.upgrade_policy
  remote_network_config                        = var.remote_network_config
  zonal_shift_config                           = var.zonal_shift_config
  additional_security_group_ids                = var.additional_security_group_ids
  control_plane_subnet_ids                     = var.control_plane_subnet_ids
  subnet_ids                                   = var.subnet_ids
  endpoint_private_access                      = var.endpoint_private_access
  endpoint_public_access                       = var.endpoint_public_access
  endpoint_public_access_cidrs                 = var.endpoint_public_access_cidrs
  ip_family                                    = var.ip_family
  service_ipv4_cidr                            = var.service_ipv4_cidr
  service_ipv6_cidr                            = var.service_ipv6_cidr
  outpost_config                               = var.outpost_config
  encryption_config                            = var.encryption_config
  attach_encryption_policy                     = var.attach_encryption_policy
  cluster_tags                                 = var.cluster_tags
  create_primary_security_group_tags           = var.create_primary_security_group_tags
  timeouts                                     = var.timeouts
  access_entries                               = var.access_entries
  enable_cluster_creator_admin_permissions     = var.enable_cluster_creator_admin_permissions
  create_kms_key                               = var.create_kms_key
  kms_key_description                          = var.kms_key_description
  kms_key_deletion_window_in_days              = var.kms_key_deletion_window_in_days
  enable_kms_key_rotation                      = var.enable_kms_key_rotation
  kms_key_enable_default_policy                = var.kms_key_enable_default_policy
  kms_key_owners                               = var.kms_key_owners
  kms_key_administrators                       = var.kms_key_administrators
  kms_key_users                                = var.kms_key_users
  kms_key_service_users                        = var.kms_key_service_users
  kms_key_source_policy_documents              = var.kms_key_source_policy_documents
  kms_key_override_policy_documents            = var.kms_key_override_policy_documents
  kms_key_aliases                              = var.kms_key_aliases
  create_cloudwatch_log_group                  = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days       = var.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id              = var.cloudwatch_log_group_kms_key_id
  cloudwatch_log_group_class                   = var.cloudwatch_log_group_class
  cloudwatch_log_group_tags                    = var.cloudwatch_log_group_tags
  create_security_group                        = var.create_security_group
  security_group_id                            = var.security_group_id
  vpc_id                                       = var.vpc_id
  security_group_name                          = var.security_group_name
  security_group_use_name_prefix               = var.security_group_use_name_prefix
  security_group_description                   = var.security_group_description
  security_group_additional_rules              = var.security_group_additional_rules
  security_group_tags                          = var.security_group_tags
  create_cni_ipv6_iam_policy                   = var.create_cni_ipv6_iam_policy
  create_node_security_group                   = var.create_node_security_group
  node_security_group_id                       = var.node_security_group_id
  node_security_group_name                     = var.node_security_group_name
  node_security_group_use_name_prefix          = var.node_security_group_use_name_prefix
  node_security_group_description              = var.node_security_group_description
  node_security_group_additional_rules         = var.node_security_group_additional_rules
  node_security_group_enable_recommended_rules = var.node_security_group_enable_recommended_rules
  node_security_group_tags                     = var.node_security_group_tags
  enable_irsa                                  = var.enable_irsa
  openid_connect_audiences                     = var.openid_connect_audiences
  include_oidc_root_ca_thumbprint              = var.include_oidc_root_ca_thumbprint
  custom_oidc_thumbprints                      = var.custom_oidc_thumbprints
  create_iam_role                              = var.create_iam_role
  iam_role_arn                                 = var.iam_role_arn
  iam_role_name                                = var.iam_role_name
  iam_role_use_name_prefix                     = var.iam_role_use_name_prefix
  iam_role_path                                = var.iam_role_path
  iam_role_description                         = var.iam_role_description
  iam_role_permissions_boundary                = var.iam_role_permissions_boundary
  iam_role_additional_policies                 = var.iam_role_additional_policies
  iam_role_tags                                = var.iam_role_tags
  encryption_policy_use_name_prefix            = var.encryption_policy_use_name_prefix
  encryption_policy_name                       = var.encryption_policy_name
  encryption_policy_description                = var.encryption_policy_description
  encryption_policy_path                       = var.encryption_policy_path
  encryption_policy_tags                       = var.encryption_policy_tags
  dataplane_wait_duration                      = var.dataplane_wait_duration
  enable_auto_mode_custom_tags                 = var.enable_auto_mode_custom_tags
  addons                                       = var.addons
  addons_timeouts                              = var.addons_timeouts
  identity_providers                           = var.identity_providers
  create_node_iam_role                         = var.create_node_iam_role
  node_iam_role_name                           = var.node_iam_role_name
  node_iam_role_use_name_prefix                = var.node_iam_role_use_name_prefix
  node_iam_role_path                           = var.node_iam_role_path
  node_iam_role_description                    = var.node_iam_role_description
  node_iam_role_permissions_boundary           = var.node_iam_role_permissions_boundary
  node_iam_role_additional_policies            = var.node_iam_role_additional_policies
  node_iam_role_tags                           = var.node_iam_role_tags
  fargate_profiles                             = var.fargate_profiles
  self_managed_node_groups                     = var.self_managed_node_groups
  eks_managed_node_groups                      = var.eks_managed_node_groups
  putin_khuylo                                 = var.putin_khuylo
}

resource "aws_security_group_rule" "node_to_cluster" {
  count                    = var.create && var.eks_cluster_primary_security_group_custom_rule_create ? 1 : 0
  description              = "Cluster node to Cluster primary sg"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = module.eks[0].node_security_group_id
  security_group_id        = module.eks[0].cluster_primary_security_group_id
}

resource "aws_security_group_rule" "from_fargate_to_cluster_dns_udp" { #allow to make DNS request from fargate nodes to DNS hosted on ec2
  count                    = var.create && var.eks_cluster_allow_dns_from_cluster_to_nodes ? 1 : 0
  description              = "From cluster to nodes UDP/53"
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "udp"
  source_security_group_id = module.eks[0].cluster_primary_security_group_id
  security_group_id        = module.eks[0].node_security_group_id
}

resource "aws_security_group_rule" "from_fargate_to_cluster_dns_tcp" { #allow to make DNS request from fargate nodes to DNS hosted on ec2
  count                    = var.create && var.eks_cluster_allow_dns_from_cluster_to_nodes ? 1 : 0
  description              = "From cluster to nodes TCP/53"
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "tcp"
  source_security_group_id = module.eks[0].cluster_primary_security_group_id
  security_group_id        = module.eks[0].node_security_group_id
}
