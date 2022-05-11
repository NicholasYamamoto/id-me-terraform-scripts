# Creating and configuring a GSA to bind to a KSA to provide Workload Identity Federation
resource "google_service_account" "gsa" {
  account_id = "${var.app_name}-gsa"
}

# Establishing all the roles needed for my application to work properly
# Unfortunately the Google Terraform provider does not offer a way to assign multiple roles at once, so I must
# call the same Resource block over and over...
# Reference: https://github.com/hashicorp/terraform-provider-google/issues/3478#issuecomment-485863424

# Grant access to GCS buckets
resource "google_project_iam_member" "gsa-storage-admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.gsa.email}"
}

# Grant access to Kubernetes Secrets
resource "google_project_iam_member" "gsa-secretmanager-admin" {
  project = var.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.gsa.email}"
}

# Grant access to the Compute service
resource "google_project_iam_member" "gsa-compute-admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.gsa.email}"
}

# Grant access to the Artifact Registry
resource "google_project_iam_member" "gsa-artifactregistry-reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gsa.email}"
}

# Bind GSA to KSA as a Workload Identity User
resource "google_service_account_iam_member" "gsa" {
  service_account_id = google_service_account.gsa.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/ksa]"
}