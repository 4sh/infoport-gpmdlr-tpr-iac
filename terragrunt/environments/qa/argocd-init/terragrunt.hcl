include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:4sh/4sh-terraform-libs.git//shared/modules/argocd-init"
}

locals {
  # Automatically load the global-level variables
  global_vars      = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}
generate "version" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    terraform {
      required_providers {
        argocd = {
          source = "oboukili/argocd"
          version = "6.0.2"
        }
      }
    }
  EOF
}
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  provider "vault" {
    address = "${local.global_vars.locals.vault_address}"
  }

  provider "argocd" {
    server_addr = "argocd.quatre.systems:443"
    username    = "admin"
    password    = data.vault_generic_secret.argocd-password.data["password"]
  }


  EOF
}

inputs = {
  customer = local.global_vars.locals.customer
  product  = local.global_vars.locals.product
  environment = local.environment_vars.locals.environment
  argocd_cluster_name = local.environment_vars.locals.argocd_cluster_name
  git_ops_repo_url = local.environment_vars.locals.git_ops_repo_url
  vault_base_path = local.global_vars.locals.vault_secret_engine
}
