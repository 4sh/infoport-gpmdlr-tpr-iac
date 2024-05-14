include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:4sh/4sh-terraform-libs.git//shared/modules/argocd-customer-app"
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
          version = "6.0.3"
        }
      }
    }
  EOF
}
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF

  provider "vault" {
    address = "${local.global_vars.locals.vault_address}"
  }

  data "vault_generic_secret" "argocd_project_token_path"{
    path = var.argocd_project_token_path
  }


  provider "argocd" {
    server_addr = "argocd.quatre.systems:443"
    auth_token = data.vault_generic_secret.argocd_project_token_path.data["token"]
  }
  EOF
}

dependency "argocd-init" {
  config_path = "../argocd-init"
}



inputs = {
  customer = local.global_vars.locals.customer
  product = local.global_vars.locals.product
  environment = local.environment_vars.locals.environment

  argocd_cluster_name = local.environment_vars.locals.argocd_cluster_name
  argocd_project_name = dependency.argocd-init.outputs.argocd_project.id
  values-repo = dependency.argocd-init.outputs.argocd_values_repo.id
  argocd_destination_namespace =  local.environment_vars.locals.application_namespace
  argocd_project_token_path = dependency.argocd-init.outputs.argocd_project_token_path

}
