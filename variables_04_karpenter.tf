variable "karpenter" {
  description = "Karpenter variables"
  type = object({
    create = optional(bool, true)
    tags   = optional(map(string), {})
    #    cluster_name = optional(string, "")
    ################################################################################
    # Karpenter controller IAM Role
    ################################################################################
    create_iam_role                   = optional(bool, true)
    iam_role_name                     = optional(string, "KarpenterController")
    iam_role_use_name_prefix          = optional(bool, true)
    iam_role_path                     = optional(string, "/")
    iam_role_description              = optional(string, "Karpenter controller IAM role")
    iam_role_max_session_duration     = optional(number, null)
    iam_role_permissions_boundary_arn = optional(string, null)
    iam_role_tags                     = optional(map(any), {})
    iam_policy_name                   = optional(string, "KarpenterController")
    iam_policy_use_name_prefix        = optional(bool, true)
    iam_policy_path                   = optional(string, "/")
    iam_policy_description            = optional(string, "Karpenter controller IAM policy")
    iam_policy_statements             = optional(any, [])
    iam_role_policies                 = optional(map(string), {})
    enable_v1_permissions             = optional(bool, false) # TODO - make v1 permssions the default policy at next breaking change
    ami_id_ssm_parameter_arns         = optional(list(string), [])
    enable_pod_identity               = optional(bool, true)
    ################################################################################
    # IAM Role for Service Account (IRSA)
    ################################################################################
    enable_irsa                     = optional(bool, false)
    irsa_oidc_provider_arn          = optional(string, "")
    irsa_namespace_service_accounts = optional(list(string), ["karpenter:karpenter"])
    irsa_assume_role_condition_test = optional(string, "StringEquals")
    ################################################################################
    # Pod Identity Association
    ################################################################################
    create_pod_identity_association = optional(bool, false)
    namespace                       = optional(string, "karpenter")
    service_account                 = optional(string, "karpenter")
    ################################################################################
    # Node Termination Queue
    ################################################################################
    enable_spot_termination                 = optional(bool, true)
    queue_name                              = optional(string, null)
    queue_managed_sse_enabled               = optional(bool, true)
    queue_kms_master_key_id                 = optional(string, null)
    queue_kms_data_key_reuse_period_seconds = optional(string, null)
    ################################################################################
    # Node IAM Role
    ################################################################################
    create_node_iam_role               = optional(bool, true)
    cluster_ip_family                  = optional(string, "ipv4")
    node_iam_role_arn                  = optional(string, null)
    node_iam_role_name                 = optional(string, null)
    node_iam_role_use_name_prefix      = optional(bool, true)
    node_iam_role_path                 = optional(string, "/")
    node_iam_role_description          = optional(string, null)
    node_iam_role_max_session_duration = optional(number, null)
    node_iam_role_permissions_boundary = optional(string, null)
    node_iam_role_attach_cni_policy    = optional(bool, true)
    node_iam_role_additional_policies  = optional(map(string), {})
    node_iam_role_tags                 = optional(map(string), {})
    ################################################################################
    # Access Entry
    ################################################################################
    create_access_entry = optional(bool, true)
    access_entry_type   = optional(string, "EC2_LINUX")
    ################################################################################
    # Node IAM Instance Profile
    ################################################################################
    create_instance_profile = optional(bool, false)
    ################################################################################
    # Event Bridge Rules
    ################################################################################
    rule_name_prefix = optional(string, "Karpenter")
  })
  default = ({
  })
}
