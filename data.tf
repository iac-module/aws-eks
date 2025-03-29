data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ssm_parameter" "ssh_key" {
  name = var.argocd.repo_credentials_configuration.param_store_repository_ssk_key
}

data "aws_ssm_parameter" "oidc_config" {
  for_each = var.argocd.oidc_auth
  name     = each.value.aws
}
