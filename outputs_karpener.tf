################################################################################
# Karpenter controller IAM Role
################################################################################

output "iam_role_name" {
  description = "The name of the controller IAM role"
  value       = try(module.karpenter[0].iam_role_name, null)
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the controller IAM role"
  value       = try(module.karpenter[0].iam_role_arn, null)
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the controller IAM role"
  value       = try(module.karpenter[0].iam_role_unique_id, null)
}

################################################################################
# Karpenter IRSA Role
################################################################################

output "karpenter_irsa_role_name" {
  description = "The name of the Karpenter IRSA IAM role"
  value       = try(module.karpenter[0].karpenter_irsa_role_name, null)
}

output "karpenter_irsa_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the Karpenter IRSA IAM role"
  value       = try(module.karpenter[0].karpenter_irsa_role_arn, null)
}

output "karpenter_irsa_role_unique_id" {
  description = "Stable and unique string identifying the Karpenter IRSA IAM role"
  value       = try(module.karpenter[0].karpenter_irsa_role_unique_id, null)
}

################################################################################
# Node Termination Queue
################################################################################

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = try(module.karpenter[0].queue_arn, null)
}

output "queue_name" {
  description = "The name of the created Amazon SQS queue"
  value       = try(module.karpenter[0].queue_name, null)
}

output "queue_url" {
  description = "The URL for the created Amazon SQS queue"
  value       = try(module.karpenter[0].queue_url, null)
}

################################################################################
# Node Termination Event Rules
################################################################################

output "event_rules" {
  description = "Map of the event rules created and their attributes"
  value       = try(module.karpenter[0].event_rules, null)
}

################################################################################
# Node IAM Role
################################################################################

output "karpenter_node_iam_role_name" {
  description = "The name of the node IAM role"
  value       = try(module.karpenter[0].node_iam_role_name, null)
}

output "karpenter_node_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the node IAM role"
  value       = try(module.karpenter[0].node_iam_role_arn, null)
}

output "karpenter_node_iam_role_unique_id" {
  description = "Stable and unique string identifying the node IAM role"
  value       = try(module.karpenter[0].node_iam_role_unique_id, null)
}

################################################################################
# Access Entry
################################################################################

output "node_access_entry_arn" {
  description = "Amazon Resource Name (ARN) of the node Access Entry"
  value       = try(module.karpenter[0].node_access_entry_arn, null)
}

################################################################################
# Node IAM Instance Profile
################################################################################

output "instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = try(module.karpenter[0].instance_profile_arn, null)
}

output "instance_profile_id" {
  description = "Instance profile's ID"
  value       = try(module.karpenter[0].instance_profile_id, null)
}

output "instance_profile_name" {
  description = "Name of the instance profile"
  value       = try(module.karpenter[0].instance_profile_name, null)
}

output "instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = try(module.karpenter[0].instance_profile_unique, null)
}

################################################################################
# Pod Identity
################################################################################

output "namespace" {
  description = "Namespace associated with the Karpenter Pod Identity"
  value       = try(module.karpenter[0].namespace, null)
}

output "service_account" {
  description = "Service Account associated with the Karpenter Pod Identity"
  value       = try(module.karpenter[0].service_account, null)
}
