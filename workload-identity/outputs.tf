output "google_service_account_email" {
  value       = google_service_account.cloud-sql-gsa.email
  description = "The email address of the CloudSQL Service Account"
}

output "kubernetes_service_account_id" {
  value       = kubernetes_service_account.ksa-cloud-sql.id
  description = "The id of the CloudSQL Kubernetes Service Account"
}
