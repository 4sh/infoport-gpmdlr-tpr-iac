# Generate a random password for the postgres root user
resource "random_password" "postgres_root_password" {
  length           = 16
  special          = true
  override_special = "()_+"
}

# Generate a random password for the postgres replication user
resource "random_password" "replication_password" {
  length           = 16
  special          = true
  override_special = "()_+"
}

# Store the postgres root password and replication user password in vault
resource "vault_generic_secret" "postgres_root_password" {
  path      = "${local.vault_secret_engine}/${var.product}/${var.environment}/postgres/postgres_root"
  data_json = <<EOT
    {
      "postgres": "${random_password.postgres_root_password.result}",
      "${var.postgres_replication_user}": "${random_password.replication_password.result}"
    }
    EOT
}

# Generate a random password for the postgres user
resource "random_password" "postgres_user_password" {
  length           = 16
  special          = true
  override_special = "()_+"
}

# Store the postgres user password in vault
resource "vault_generic_secret" "postgres_user_password" {
  path      = "${local.vault_secret_engine}/${var.product}/${var.environment}/postgres/postgres_user"
  data_json = <<EOT
    {
      "${var.postgres_username}": "${random_password.postgres_user_password.result}"
    }
    EOT
}

# Create the argocd application for the postgres helm chart
resource "argocd_application" "helm_postgres" {
  metadata {
    name = "${var.customer}-${var.product}-postgres-${var.environment}"
  }

  spec {
    project = var.argocd_project_name

    source {
      repo_url        = var.postgres_helm_repo_url
      chart           = var.postgres_helm_chart_name
      target_revision = var.postgres_helm_chart_version
      helm {
        release_name = "postgres-${var.customer}"
        value_files  = ["$values/argocd/${var.environment}/postgres/values.yaml"]

        ## Set the postgres auth values
        parameter {
          name  = "auth.password"
          value = vault_generic_secret.postgres_user_password.data[var.postgres_username]
        }
        parameter {
          name  = "auth.username"
          value = var.postgres_username
        }
        parameter {
          name  = "auth.database"
          value = var.postgres_database
        }
        ## Enable the postgres root user
        parameter {
          name  = "auth.enablePostgresUser"
          value = var.postgres_root_enable
        }
        parameter {
          name  = "auth.postgresPassword"
          value = vault_generic_secret.postgres_root_password.data["postgres"]
        }
        ## Enable the replication user
        parameter {
          name  = "auth.replicationUser"
          value = var.postgres_replication_user
        }
        parameter {
          name  = "auth.replicationPassword"
          value = vault_generic_secret.postgres_root_password.data[var.postgres_replication_user]
        }


      }
    }

    source {
      repo_url        = var.values-repo
      target_revision = var.values-repo-branch
      ref             = "values"
    }

    destination {
      name      = var.argocd_cluster_name
      namespace = var.argocd_destination_namespace
    }
    sync_policy {
      sync_options = ["RespectIgnoreDifferences=true"]
    }
  }
}