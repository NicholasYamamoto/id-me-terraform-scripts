output "region" {
  value       = var.region
  description = "The region the GKE cluster was deployed to"
}

output "project_id" {
  value       = var.project_id
  description = "The Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "The GKE cluster name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "The GKE cluster host IP address"
}

output "google_service_account_email" {
  value       = google_service_account.gke-sa.email
  description = "The email address of the GKE GSA Service Account"
}
