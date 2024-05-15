# This is the configuration file for the infoport-gpmdlr-tpr-qa environment
locals {
  environment = "qa"
  application_namespace = "infoport-tpr-qa"
  ## GKE cluster
  gke_cluster_name     = "quatreapp-cl" # Name of the GKE cluster
  gke_cluster_project  = "quatreapp" # GCP project where the GKE cluster is located
  gke_cluster_location = "europe-west1-c" # Location of the GKE cluster

  ## Vault resources
  vault_custom_readers = ["elian.oriou@4sh.fr","kamlinne-bebora.ly@4sh.fr","benjamin.letourneau@4sh.fr","test_user@4sh.fr"]

  ## ArgoCD resources
  argocd_cluster_name = "quatreapp-cl" # Name of the ArgoCD cluster
  argocd_namespace = "argocd" # Namespace where CRDS for ArgoCD Application is installed
  git_ops_repo_url = "https://github.com/4sh/infoport-gpmdlr-tpr-k8s.git"

  ## Namespace resources
  nsadmin_group_members = ["elian.oriou@4sh.fr","kamlinne-bebora.ly@4sh.fr","benjamin.letourneau@4sh.fr"]
  ingress_role_label    = "nginx"
  ## ArgoCD Applications
  # MongoDB
  mongo_helm_chart_version   = "14.5.0"
  mongodb_users              = [
    {
      "username" : "infoport-tpr-user",
      "db" : "infoport-tpr"
    }
  ]
  # PostgreSQL
  postgres_helm_chart_version = "15.3.0"
  postgres_database = "keycloak"
  postgres_username = "keycloak"

  # Keycloak
  keycloak_helm_chart_version = "21.1.3"


}