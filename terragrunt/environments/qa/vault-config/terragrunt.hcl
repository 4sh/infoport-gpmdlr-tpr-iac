include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:4sh/4sh-terraform-libs.git//shared/modules/vault-config?ref=main"

  extra_arguments "env_vars"  {
    commands = ["apply", "plan"]
    env_vars = {
      KUBECONFIG = "./cluster.kubeconfig"
    }
  }

  before_hook "fetch_kubernetes_config" {
  commands = ["apply", "plan"]
  execute  = ["gcloud", "container", "clusters", "get-credentials",
    "--project", "${local.environment_vars.locals.gke_cluster_project}",
    "${local.environment_vars.locals.gke_cluster_name}",
    "--region", "${local.environment_vars.locals.gke_cluster_location}"]
    }
}

locals {
  # Automatically load the global-level variables
  global_vars      = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    provider "kubernetes" {
      config_path = "./cluster.kubeconfig"
    }
    provider "vault" {
      address = "${local.global_vars.locals.vault_address}"
    }
  EOF
}

inputs = {
  customer = local.global_vars.locals.customer
  product  = local.global_vars.locals.product
  environment = local.environment_vars.locals.environment

  cluster_name = local.environment_vars.locals.gke_cluster_name
  cluster_location = local.environment_vars.locals.gke_cluster_location
  gcp_project = local.environment_vars.locals.gke_cluster_project

  vault_secret_engine = local.global_vars.locals.vault_secret_engine
  custom_readers = local.environment_vars.locals.vault_custom_readers
}
