# define root level variables
locals {
  customer = "infoport"
  product = "tpr"


  # Vault address
  vault_address = "https://vault.quatre.systems"
  registry_project = "quatreapp"
  vault_secret_engine = "infoport"

}
# Convert local variables to inputs
inputs = local

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "gcs" {
    bucket = "qsh-infra-terraform"
    prefix = "terraform/state/${local.customer}/${local.product}/${path_relative_to_include()}"
  }
}
EOF
}