# Creating the k8s cluster
resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.region
  description              = "A k8s cluster to house the id-me-hello-world-app and the monitoring stack"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.primary.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  # Disabling the StackDriver monitoring service as I'll be using Prometheus instead
  monitoring_service = "none"
  networking_mode    = "VPC_NATIVE"

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    http_load_balancing {
      disabled = true
    }

  }

  # Enabling node auto-provisioning
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 2
      maximum       = 8
    }

    resource_limits {
      resource_type = "memory"
      minimum       = 10
      maximum       = 1000
    }

  }

  # Enabling Workload Identity Federation for the cluster to improve overall security
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Linking the IP allocation policy to the private secondary IP ranges created earlier
  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

}

# Creating a Separately-managed Node Pool to follow GCP best practices
resource "google_container_node_pool" "primary_nodes" {
  name               = var.gke_node_pool
  location           = var.region
  cluster            = google_container_cluster.primary.id
  initial_node_count = 3

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 15
  }

  node_config {
    machine_type = var.machine_type
    preemptible  = false

    labels = {
      env = var.project_id
      app = var.app_name
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    service_account = google_service_account.gke-sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags = ["gke-node", "${var.cluster_name}"]
  }
}

# Creating a GKE Service Account for the cluster
resource "google_service_account" "gke-sa" {
  account_id   = "${var.app_name}-gke-sa"
  display_name = "GKE Service Account"
  project      = var.project_id
}

# Granting Cloud Storage access to the GKE GSA
resource "google_project_iam_member" "gke-gsa-storage-admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.gke-sa.email}"
}

# Adding the GKE Service Account to the project
resource "google_project_iam_member" "service-account" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.gke-sa.email}"
}

# Creating Cloud Storage buckets to securely store the .tfstate files of each module
# Creating gke bucket
resource "google_storage_bucket" "gke-bucket" {
  name          = "gke-tfstate-bucket"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Creating workload-identity bucket
resource "google_storage_bucket" "workload-identity-bucket" {
  name          = "workload-identity-tfstate-bucket"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Creating web-app bucket
resource "google_storage_bucket" "web-app-bucket" {
  name          = "web-app-tfstate-bucket"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Creating monitoring bucket
resource "google_storage_bucket" "monitoring-bucket" {
  name          = "monitoring-tfstate-bucket"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}