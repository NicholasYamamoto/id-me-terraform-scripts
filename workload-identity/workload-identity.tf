data "google_client_config" "provider" {}

data "google_container_cluster" "id-me-hello-world-app-k8s-cluster" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.region
}


# Creating a GSA to bind to a KSA to provide Workload Identity Federation
resource "google_service_account" "cloud-sql-gsa" {
  account_id = "${var.app_name}-sql-gsa"
}

# Creating the base Kubernetes Service Account
resource "kubernetes_service_account" "ksa-cloud-sql" {
  metadata {
    name      = var.k8s_service_account
    namespace = var.k8s_namespace
  }
}

# Annotating the Kubernetes Service Account with the GSA email
resource "kubernetes_annotations" "ksa-cloud-sql-annotation" {
  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name      = var.k8s_service_account
    namespace = var.k8s_namespace
  }

  annotations = {
    "iam.gke.io/gcp-service-account" = google_service_account.cloud-sql-gsa.email
  }

  force = true
}

# Creating an IAM policy to allow the k8s_service_account to be used as a Workload Identity User
data "google_iam_policy" "access-cloud-sql" {
  binding {
    role = "roles/iam.workloadIdentityUser"

    members = [
      format("serviceAccount:%s.svc.id.goog[%s/%s]", var.project_id, var.k8s_namespace, var.k8s_service_account)
    ]
  }
}

# Binding the Workload Identity IAM policy to the Google Service Account
resource "google_service_account_iam_policy" "access-cloud-sql" {
  service_account_id = google_service_account.cloud-sql-gsa.name
  policy_data        = data.google_iam_policy.access-cloud-sql.policy_data
}

# Enabling CloudSQL access permissions to the Google Service Account
resource "google_project_iam_binding" "access-cloud-sql" {
  project = var.project_id
  role    = "roles/cloudsql.client"

  members = [
    format("serviceAccount:%s", google_service_account.cloud-sql-gsa.email)
  ]
}

# Establishing all the roles needed for my application to work properly
# Unfortunately the Google Terraform provider does not offer a way to assign multiple roles at once, so I must
# call the same Resource block over and over...
# Reference: https://github.com/hashicorp/terraform-provider-google/issues/3478#issuecomment-485863424

# Granting access to Kubernetes Secrets
resource "google_project_iam_member" "gsa-secretmanager-admin" {
  project = var.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.cloud-sql-gsa.email}"
}

# Granting access to the Compute service
resource "google_project_iam_member" "gsa-compute-admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.cloud-sql-gsa.email}"
}

# Granting access to the Artifact Registry
resource "google_project_iam_member" "gsa-artifactregistry-reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cloud-sql-gsa.email}"
}

