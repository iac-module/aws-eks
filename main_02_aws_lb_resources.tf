
module "s3_bucket_for_logs" {
  count  = var.aws_lb_resources.create && var.create ? 1 : 0
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=a1629887065e1132c1b819de0e75d8755c391d65" #v5.2.0

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

  source                                 = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-role-for-service-accounts-eks?ref=0792d7f2753c265e3d610a58348fa1c551cbe4b8" #v5.59.0
  role_name                              = format("${var.aws_lb_resources.role_name}%s", var.name)
  attach_load_balancer_controller_policy = true
  role_permissions_boundary_arn          = var.aws_lb_resources.role_permissions_boundary_arn
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
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks-pod-identity?ref=9478c492d293927d658503fc26b0fec5a30e92bd" #v1.12.1

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
