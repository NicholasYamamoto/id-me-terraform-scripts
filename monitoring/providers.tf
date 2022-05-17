terraform {
  backend "gcs" {
    bucket = "monitoring-tfstate-bucket"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }

    newrelic = {
      source  = "newrelic/newrelic"
      version = "2.45.1"
    }
  }
}

data "google_client_config" "provider" {}

data "google_container_cluster" "id-me-hello-world-app-k8s-cluster" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.region
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

provider "newrelic" {
  account_id = var.new_relic_account_id
  api_key    = var.new_relic_user_api_key
  region     = "US"
}
