# Main config
variable "customer" {
  type        = string
  description = "The customer name (e.g. qsh, mso, etc)"
}
variable "product" {
  type        = string
  description = "The product name (e.g. orders, payments, etc)"
}
variable "environment" {
  type        = string
  description = "The environment type (e.g. qa, acceptance, prod, etc)"
}
# ArgoCD config
variable "argocd_cluster_name" {
  type        = string
  description = "The name of the ArgoCD cluster"
}
variable "argocd_project_name" {
  type        = string
  description = "The name of the ArgoCD project"
}
variable "argocd_project_token_path" {
  type        = string
  description = "The vault path to the ArgoCD project token"
}
variable "keycloak_helm_repo_url" {
  type        = string
  description = "The URL of the keycloak Helm repository"
  default     = "registry-1.docker.io/bitnamicharts"
}
variable "keycloak_helm_chart_name" {
  type        = string
  description = "The name of the keycloak Helm chart"
  default     = "keycloak"
}
variable "keycloak_helm_chart_version" {
  type        = string
  description = "The version of the keycloak Helm chart"
  default     = "21.1.3"
}
variable "values-repo" {
  type        = string
  description = "The URL of the values repository"
}
variable "values-repo-branch" {
  type        = string
  description = "The branch of the values repository"
  default     = "main"
}
variable "argocd_destination_namespace" {
  type        = string
  description = "The namespace where the ArgoCD application will be deployed"
}
# Vault config
variable "vault_secret_engine" {
  type        = string
  description = "The name of the Vault secret engine (Defaulted to var.customer)"
  default     = ""
}
variable "postgres_password_path" {
  type = string
  description = "The path to the postgres password in Vault"
}

# Keycloak config
variable "keycloak_admin_username" {
  type        = string
  description = "The Keycloak admin username"
  default     = "admin"
}

variable "postgres_database" {
  type = string
  description = "The name of the postgres database"
  default = "keycloak"
}
variable "postgres_username" {
  type = string
  description = "The name of the postgres user"
  default = "keycloak"
}

locals {
  # Change the name of the secret engine if it is not set
  vault_secret_engine = var.vault_secret_engine != "" ? var.vault_secret_engine : var.customer
}