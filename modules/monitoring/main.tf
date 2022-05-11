data "google_client_config" "provider" {}

data "google_container_cluster" "id-me-hello-world-app-k8s-cluster" {
  name     = var.cluster_name
  location = var.region
}

# Deploy a Helm chart to create and configure an Nginx ingress controller for the cluster
resource "helm_release" "prometheus-deployment" {
  name       = "prometheus-deployment"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-community/kube-prometheus-stack"
  version    = "35.2.0"
  values = [
    "${file("values.yaml")}"
  ]
}