terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.id-me-hello-world-app-k8s-cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.id-me-hello-world-app-k8s-cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}