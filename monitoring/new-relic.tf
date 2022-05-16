# Granting the GSA access to view the project services
resource "google_project_iam_member" "new-relic-gsa-viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${var.new_relic_service_account}"
}

# Granting the GSA access to service usage metrics
resource "google_project_iam_binding" "new-relic-gsa-service-usage" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageConsumer"

  members = [
    "serviceAccount:${var.new_relic_service_account}"
  ]
}

# Linking my New Relic account to the GCP infrastructure
resource "newrelic_cloud_gcp_link_account" "gcp-account" {
  project_id = var.project_id
  name       = "GCP-linked Account"
}

# Creating some basic GCP integrations for my project
resource "newrelic_cloud_gcp_integrations" "gcp-integrations" {
  linked_account_id = newrelic_cloud_gcp_link_account.gcp-account.id
  kubernetes {}
  load_balancing {}
  router {}
  sql {}
  storage {}
  virtual_machines {}
  vpc_access {}
}