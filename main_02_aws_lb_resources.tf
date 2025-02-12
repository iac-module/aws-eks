
module "s3_bucket_for_logs" {
  count  = var.aws_lb_resources.create && var.create ? 1 : 0
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=fc09cc6fb779b262ce1bee5334e85808a107d8a3" #v4.6.0

  bucket                   = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-${var.aws_lb_resources.bucket_suffix}"
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
  count = var.aws_lb_resources.create && var.create ? 1 : 0

  source                                 = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-role-for-service-accounts-eks?ref=e803e25ce20a6ebd5579e0896f657fa739f6f03e" #v5.52.2
  role_name                              = format("${var.aws_lb_resources.role_name}%s", var.cluster_name)
  attach_load_balancer_controller_policy = true
  role_permissions_boundary_arn          = var.aws_lb_resources.role_permissions_boundary_arn
  oidc_providers = {
    ex = {
      provider_arn               = module.eks[0].oidc_provider_arn
      namespace_service_accounts = var.aws_lb_resources.namespace_service_accounts
    }
  }
  tags = var.aws_lb_resources.tags
}
