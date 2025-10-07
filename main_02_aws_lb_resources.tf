
module "s3_bucket_for_logs" {
  count  = var.aws_lb_resources.create && var.create ? 1 : 0
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=c375418373496865e2770ad8aabfaf849d4caee5" #v5.7.0

  bucket                   = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}-${var.aws_lb_resources.bucket_suffix}"
  acl                      = "log-delivery-write"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
  # Allow deletion of non-empty bucket
  force_destroy = true

  attach_elb_log_delivery_policy        = true
  attach_lb_log_delivery_policy         = true
  attach_deny_insecure_transport_policy = true
  tags                                  = var.aws_lb_resources.tags
}

module "lb_controller_irsa" {
  count = var.aws_lb_resources.create && var.aws_lb_resources.enable_irsa ? 1 : 0

  source                                 = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-role-for-service-accounts?ref=dc7a9f3bed20aaaba05d151b0789745070424b3a" #v6.2.1
  name                                   = format("${var.aws_lb_resources.role_name}%s", var.name)
  attach_load_balancer_controller_policy = true
  permissions_boundary                   = var.aws_lb_resources.role_permissions_boundary_arn
  oidc_providers = {
    ex = {
      provider_arn               = module.eks[0].oidc_provider_arn
      namespace_service_accounts = ["${var.aws_lb_resources.namespace}:${var.aws_lb_resources.service_account}"]
    }
  }
  tags = var.aws_lb_resources.tags
}

module "aws_lb_controller_pod_identity" {
  count  = var.aws_lb_resources.create && var.aws_lb_resources.enable_pod_identity ? 1 : 0
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks-pod-identity?ref=6dd790f10334e85639e53e1c6a2409479b28ecf4" #v2.0.0

  name                            = format("${var.aws_lb_resources.role_name}%s", var.name)
  attach_aws_lb_controller_policy = true
  associations = {
    lb-controller = {
      cluster_name    = module.eks[0].cluster_name
      namespace       = var.aws_lb_resources.namespace
      service_account = var.aws_lb_resources.service_account
    }
  }
  tags = var.aws_lb_resources.tags
}
