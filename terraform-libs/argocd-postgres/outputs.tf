output "vault_postgres_user_path" {
  value = "${local.vault_secret_engine}/${var.product}/${var.environment}/postgres/postgres_user"
}



