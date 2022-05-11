# Enabling APIs needed to create the VPC
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

# Creating the VPC
resource "google_compute_network" "primary" {
  name                            = "${var.app_name}-vpc"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]

}

# Creating a private subnet to use to assign IP addresses to k8s Pods and Services
resource "google_compute_subnetwork" "private" {
  name                     = "${var.app_name}-private-subnet"
  ip_cidr_range            = "10.0.0.0/18"
  region                   = var.region
  network                  = google_compute_network.primary.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }

  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}

resource "google_compute_router" "router" {
  name    = "${var.app_name}-router"
  region  = var.region
  network = google_compute_network.primary.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.app_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]
}

# Creating a service to allocate an External IP address
resource "google_compute_address" "nat" {
  name         = "${var.app_name}-external-ip-address-allocater"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [google_project_service.compute]
}