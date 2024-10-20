data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ssm_parameter" "repo_ssh_key" {
  name = var.argocd.repo_credentials_configuration.param_store_repository_ssk_key
}

data "aws_ssm_parameter" "oidc_client_secret" {
  count = var.argocd.oidc_auth.create ? 1 : 0
  name  = var.argocd.oidc_auth.aws
}
