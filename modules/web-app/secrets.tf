data "google_client_config" "provider" {}

data "google_container_cluster" "id-me-hello-world-app-k8s-cluster" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.region
}

# Create the Kubernetes Secrets used to connect to the CloudSQL instance from my app
resource "kubernetes_secret" "ruby-credentials" {
  metadata {
    name = "ruby-credentials"
  }
  data = {
    rails_secret_key_base = "${var.rails_secret_key_base}"
  }
  type = "Opaque"
}

resource "kubernetes_secret" "cloudsql-db-credentials" {
  metadata {
    name = "cloudsql-db-credentials"
  }
  data = {
    database = "${var.database_name}"
    username = "${var.database_username}"
    password = "${var.database_password}"
  }
  type = "Opaque"
}