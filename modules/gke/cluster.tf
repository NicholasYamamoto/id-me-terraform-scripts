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

    # Disabling GKE built-in one as I'll be using an Nginx Ingress controller instead
    http_load_balancing {
      disabled = true
    }

  }

  # Enabling node auto-provisioning
  # But disabling it for demo purposes!
  # cluster_autoscaling {
  #   enabled = true
  #   resource_limits {
  #     resource_type = "cpu"
  #     minimum       = 2
  #     maximum       = 8
  #   }

  #   resource_limits {
  #     resource_type = "memory"
  #     minimum       = 10
  #     maximum       = 1000
  #   }

  # }

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

# Create a Separately-managed Node Pool to follow best practices
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

    service_account = google_service_account.gsa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags = ["gke-node", "${var.cluster_name}"]
  }
}
