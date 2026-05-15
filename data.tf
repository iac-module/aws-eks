data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ssm_parameter" "ssh_key" {
  count = var.argocd.repo_credentials_configuration.use_secrets_manager ? 0 : 1
  name  = var.argocd.repo_credentials_configuration.param_store_repository_ssk_key
}

data "aws_secretsmanager_secret_version" "github_app" {
  count     = var.argocd.repo_credentials_configuration.use_secrets_manager ? 1 : 0
  secret_id = var.argocd.repo_credentials_configuration.secrets_manager_name
}

data "aws_ssm_parameter" "oidc_config" {
  for_each = { for k, v in var.argocd.oidc_auth : k => v if !v.use_secrets_manager }
  name     = each.value.aws
}

data "aws_secretsmanager_secret_version" "oidc_config" {
  for_each  = { for k, v in var.argocd.oidc_auth : k => v if v.use_secrets_manager }
  secret_id = each.value.secrets_manager_name
}
