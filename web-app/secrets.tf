data "google_client_config" "provider" {}

data "google_container_cluster" "id-me-hello-world-app-k8s-cluster" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.region
}

# Create a k8s secret to store the rails_secret_key_base required to connect to SQL database in Production environment
resource "kubernetes_secret" "ruby-credentials" {
  metadata {
    name = "ruby-credentials"
  }
  data = {
    rails_secret_key_base = "${var.rails_secret_key_base}"
  }
  type = "Opaque"
}

# Create a k8s secret to store the CloudSQL database credentials
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