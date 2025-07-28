output "aws_lb_resources_s3_bucket_id" {
  description = "The name of the bucket."
  value       = try(module.s3_bucket_for_logs[0].s3_bucket_id, "")
}

output "s3_aws_lb_resources_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(module.s3_bucket_for_logs[0].s3_bucket_arn, "")
}

output "s3_aws_lb_resources_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = try(module.s3_bucket_for_logs[0].s3_bucket_bucket_domain_name, "")
}

output "s3_aws_lb_resources_bucket_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = try(module.s3_bucket_for_logs[0].s3_bucket_bucket_regional_domain_name, "")
}

output "s3_aws_lb_resources_bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = try(module.s3_bucket_for_logs[0].s3_bucket_hosted_zone_id, "")
}

output "s3_aws_lb_resources_bucket_lifecycle_configuration_rules" {
  description = "The lifecycle rules of the bucket, if the bucket is configured with lifecycle rules. If not, this will be an empty string."
  value       = try(module.s3_bucket_for_logs[0].s3_bucket_lifecycle_configuration_rules, "")
}

output "s3_aws_lb_resources_bucket_policy" {
  description = "The policy of the bucket, if the bucket is configured with a policy. If not, this will be an empty string."
  value       = try(module.s3_bucket_for_logs[0].s3_bucket_policy, "")
}

output "s3_aws_lb_resources_bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = try(module.s3_bucket_for_logs[0].s3_bucket_region, "")
}

output "s3_aws_lb_resources_bucket_website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  value       = try(module.s3_bucket_for_logs[0].s3_bucket_website_endpoint, "")
}

output "s3_aws_lb_resources_bucket_website_domain" {
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records."
  value       = try(module.s3_bucket_for_logs[0].s3_bucket_website_domain, "")
}

################################################################################
# AWS Load Balancer Controller Pod Identity
################################################################################

output "aws_lb_controller_pod_identity_role_name" {
  description = "The name of the AWS Load Balancer Controller pod identity IAM role"
  value       = try(module.aws_lb_controller_pod_identity[0].iam_role_name, null)
}

output "aws_lb_controller_pod_identity_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the AWS Load Balancer Controller pod identity IAM role"
  value       = try(module.aws_lb_controller_pod_identity[0].iam_role_arn, null)
}

output "aws_lb_controller_pod_identity_role_unique_id" {
  description = "Stable and unique string identifying the AWS Load Balancer Controller pod identity IAM role"
  value       = try(module.aws_lb_controller_pod_identity[0].iam_role_unique_id, null)
}

output "aws_lb_controller_pod_identity_associations" {
  description = "Map of AWS Load Balancer Controller pod identity associations created and their attributes"
  value       = try(module.aws_lb_controller_pod_identity[0].associations, null)
}
