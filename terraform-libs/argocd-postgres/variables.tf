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
variable "postgres_helm_repo_url" {
  type        = string
  description = "The URL of the postgres Helm repository"
  default     = "registry-1.docker.io/bitnamicharts"
}
variable "postgres_helm_chart_name" {
  type        = string
  description = "The name of the postgres Helm chart"
  default     = "postgresql"
}
variable "postgres_helm_chart_version" {
  type        = string
  description = "The version of the postgres Helm chart"
  default     = "15.3.0"
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
# Postgres values
variable "postgres_username" {
  type        = string
  description = "The username for the postgres user"
}
variable "postgres_database" {
  type        = string
  description = "The name of the postgres database"
}
variable "postgres_root_enable" {
  type        = bool
  description = "Enable the root user for the postgres database"
  default     = true
}
variable "postgres_replication_user" {
  type        = string
  default = "repl_user"
}


locals {
  # Change the name of the secret engine if it is not set
  vault_secret_engine = var.vault_secret_engine != "" ? var.vault_secret_engine : var.customer
}