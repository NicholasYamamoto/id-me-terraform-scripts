output "region" {
  value       = var.region
  description = "The region the GKE cluster was deployed to"
}

output "project_id" {
  value       = var.project_id
  description = "The Project ID"
}

output "load_balancer_external_ip" {
  value       = kubernetes_service.app-service.status.0.load_balancer.0.ingress.0.ip
  description = "The external IP address of the LoadBalancer service where the app can be accessed"
}