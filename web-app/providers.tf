terraform {
  backend "gcs" {
    bucket = "web-app-tfstate-bucket"
    prefix = "terraform/state"
  }
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}

data "google_client_config" "provider" {}

data "google_container_cluster" "id-me-hello-world-app-k8s-cluster" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.region
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.id-me-hello-world-app-k8s-cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.id-me-hello-world-app-k8s-cluster.master_auth[0].cluster_ca_certificate,
  )
}
