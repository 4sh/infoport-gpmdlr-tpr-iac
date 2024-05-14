# Terragrunt project template

## Description

This project is created from 4sh IaC template repository. It includes a basic structure for a Terragrunt project, with a few modules and a few examples.

# Terragrunt root directory
Contains the global terragrunt configuration files for the project.
The `terragrunt.hcl` file contains the global configuration for the project.
Generate the `backend.tf` for each module.
Many variables are predefined.

## Environment
Each environment is defined in the `environment` directory.
Each environment is a directory containing a `terragrunt.hcl` file.
The `env.hcl` file contains environment specific variable.

## Terraform-libs

Contains project specific modules used in the project.pmdlr-tpr-iac