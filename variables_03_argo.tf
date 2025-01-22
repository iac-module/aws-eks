variable "argocd" {
  description = "ArgoCD variables"
  type = object({
    create             = optional(bool, true)
    tags               = optional(map(string), {})
    namespace          = optional(string, "argo")
    extra_command_arg  = optional(list(string), [])
    chart_repo         = optional(string, "https://argoproj.github.io/argo-helm")
    chart_name         = optional(string, "argo-cd")
    chart_version      = optional(string, "7.7.16")
    helm_release_name  = optional(string, "argocd")
    app_project_name   = optional(string, "cluster-addons")
    path_to_values     = optional(string, "argocd-values.yaml")
    automated_prune    = optional(string, "false")
    automated_selfHeal = optional(string, "true")
    repo_credentials_configuration = object({
      repo_url                       = string
      secret_name                    = optional(string, "argocd-infra-deployment-repo")
      param_store_repository_ssk_key = string
    })
    app_of_apps = optional(object({
      name              = optional(string, "apps")
      path              = optional(string, "")
      chart_repo        = optional(string, "https://argoproj.github.io/argo-helm")
      chart_name        = optional(string, "argocd-apps")
      chart_version     = optional(string, "2.0.2")
      helm_release_name = optional(string, "argocd-apps")
      repository = optional(object({
        path           = optional(string, "")
        url            = optional(string, "git@github.com:X/Y-K8S-INFRA.git")
        targetRevision = optional(string, "HEAD")
      }))
    }))
    oidc_auth = optional(object({
      create = optional(bool, true)
      ## AWS Secret Manager path.
      aws = optional(string, "argocd-oidc-config")
      ## Kubernetes secret name
      k8s = optional(string, "argocd-oidc-config")
    }))
  })
}
