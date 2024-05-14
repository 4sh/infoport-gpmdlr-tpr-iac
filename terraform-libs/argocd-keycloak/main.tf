# generare the keycloak admin password
resource "random_password" "keycloak_admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
# Store the keycloak admin password in Vault
resource "vault_generic_secret" "keycloak_admin_password" {
#  path = "secret/${var.customer}/${var.product}/${var.environment}/keycloak-admin-password"
  path = "${local.vault_secret_engine}/${var.product}/${var.environment}/keycloak/admin-password"
  data_json = <<EOF
  {
    "${var.keycloak_admin_username}": "${random_password.keycloak_admin_password.result}"
  }
EOF
}
# Fetch the postgres password from Vault
data "vault_generic_secret" "postgres_password" {
  path = var.postgres_password_path
}


# Create the argocd application for the keycloak helm chart
resource "argocd_application" "helm_keycloak" {
  metadata {
    name = "${var.customer}-${var.product}-keycloak-${var.environment}"
  }

  spec {
    project = var.argocd_project_name

    source {
      repo_url        = var.keycloak_helm_repo_url
      chart           = var.keycloak_helm_chart_name
      target_revision = var.keycloak_helm_chart_version
      helm {
        release_name = "keycloak-${var.customer}"
        value_files  = ["$values/argocd/${var.environment}/keycloak/values.yaml"]

        ## Set the keycloak values
        parameter {
          name  = "auth.adminUser"
          value = var.keycloak_admin_username
        }
        parameter {
          name  = "auth.adminPassword"
          value = vault_generic_secret.keycloak_admin_password.data[var.keycloak_admin_username]
        }
        parameter {
          name  = "postgresql.enabled"
          value = "false"
        }
        parameter {
          name  = "externalDatabase.host"
          value = "postgres-${var.customer}-postgresql"
        }
        parameter {
          name  = "externalDatabase.port"
          value = "5432"
        }
        parameter {
          name  = "externalDatabase.database"
          value = var.postgres_database
        }
        parameter {
          name  = "externalDatabase.user"
          value = var.postgres_username
        }
        parameter {
          name  = "externalDatabase.password"
          value = data.vault_generic_secret.postgres_password.data[var.postgres_username]
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