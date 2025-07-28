variable "aws_lb_resources" {
  description = "AWS LB controller resources variables"
  type = object({
    create                        = optional(bool, true)
    role_name                     = optional(string, "AWSLBController-")
    role_permissions_boundary_arn = optional(string, null)
    namespace                     = optional(string, "infra-tools")
    service_account               = optional(string, "aws-load-balancer-controller")
    bucket_suffix                 = optional(string, "elb-access-logs")
    enable_irsa                   = optional(bool, false)
    enable_pod_identity           = optional(bool, true)
    tags                          = optional(map(string), {})
  })
  default = ({
  })
}
