module "karpenter" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git//modules/karpenter?ref=074abf14097264dd13fe3a521cd1d0fe76f6b4ef" #v21.0.4"
  count  = var.karpenter.create ? 1 : 0

  create                                    = var.karpenter.create
  tags                                      = var.karpenter.tags
  cluster_name                              = module.eks[0].cluster_name
  region                                    = var.karpenter.region
  create_iam_role                           = var.karpenter.create_iam_role
  iam_role_name                             = "${var.name}-${var.karpenter.iam_role_name}"
  iam_role_use_name_prefix                  = var.karpenter.iam_role_use_name_prefix
  iam_role_path                             = var.karpenter.iam_role_path
  iam_role_description                      = var.karpenter.iam_role_description
  iam_role_max_session_duration             = var.karpenter.iam_role_max_session_duration
  iam_role_permissions_boundary_arn         = var.karpenter.iam_role_permissions_boundary_arn
  iam_role_tags                             = var.karpenter.iam_role_tags
  iam_policy_name                           = "${var.name}-${var.karpenter.iam_policy_name}"
  iam_policy_use_name_prefix                = var.karpenter.iam_policy_use_name_prefix
  iam_policy_path                           = var.karpenter.iam_policy_path
  iam_policy_description                    = var.karpenter.iam_policy_description
  iam_role_override_assume_policy_documents = var.karpenter.iam_role_override_assume_policy_documents
  iam_role_source_assume_policy_documents   = var.karpenter.iam_role_source_assume_policy_documents
  iam_policy_statements                     = var.karpenter.iam_policy_statements
  iam_role_policies                         = var.karpenter.iam_role_policies
  ami_id_ssm_parameter_arns                 = var.karpenter.ami_id_ssm_parameter_arns
  create_pod_identity_association           = var.karpenter.create_pod_identity_association
  namespace                                 = var.karpenter.namespace
  service_account                           = var.karpenter.service_account
  enable_spot_termination                   = var.karpenter.enable_spot_termination
  queue_name                                = var.karpenter.queue_name
  queue_managed_sse_enabled                 = var.karpenter.queue_managed_sse_enabled
  queue_kms_master_key_id                   = var.karpenter.queue_kms_master_key_id
  queue_kms_data_key_reuse_period_seconds   = var.karpenter.queue_kms_data_key_reuse_period_seconds
  create_node_iam_role                      = var.karpenter.create_node_iam_role
  cluster_ip_family                         = var.karpenter.cluster_ip_family
  node_iam_role_arn                         = var.karpenter.node_iam_role_arn
  node_iam_role_name                        = var.karpenter.node_iam_role_name
  node_iam_role_use_name_prefix             = var.karpenter.node_iam_role_use_name_prefix
  node_iam_role_path                        = var.karpenter.node_iam_role_path
  node_iam_role_description                 = var.karpenter.node_iam_role_description
  node_iam_role_max_session_duration        = var.karpenter.node_iam_role_max_session_duration
  node_iam_role_permissions_boundary        = var.karpenter.node_iam_role_permissions_boundary
  node_iam_role_attach_cni_policy           = var.karpenter.node_iam_role_attach_cni_policy
  node_iam_role_additional_policies         = var.karpenter.node_iam_role_additional_policies
  node_iam_role_tags                        = var.karpenter.node_iam_role_tags
  create_access_entry                       = var.karpenter.create_access_entry
  access_entry_type                         = var.karpenter.access_entry_type
  create_instance_profile                   = var.karpenter.create_instance_profile
  rule_name_prefix                          = var.karpenter.rule_name_prefix
}

resource "aws_iam_service_linked_role" "spot" {
  count            = var.karpenter.create && var.karpenter.create_spot_service_linked_role ? 1 : 0
  aws_service_name = "spot.amazonaws.com"
}

module "karpenter_irsa_role" {
  count     = var.karpenter.create && var.karpenter.iam_enable_irsa ? 1 : 0
  source    = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-role-for-service-accounts-eks?ref=0792d7f2753c265e3d610a58348fa1c551cbe4b8" #v5.59.0
  role_name = "${var.name}-${var.karpenter.iam_role_name}"
  role_policy_arns = {
    svc = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.name}-${var.karpenter.iam_role_name}"
  }
  oidc_providers = {
    main = {
      provider_arn               = module.eks[0].oidc_provider_arn
      namespace_service_accounts = ["${var.karpenter.namespace}:${var.karpenter.service_account}"]
    }
  }
}
