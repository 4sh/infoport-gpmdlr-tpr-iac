include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:4sh/4sh-terraform-libs.git//shared/modules/vault-init"
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

  provider "vault" {
    address = "${local.global_vars.locals.vault_address}"
  }
  EOF
}

inputs = {
  customer = "${local.global_vars.locals.customer}"
}
