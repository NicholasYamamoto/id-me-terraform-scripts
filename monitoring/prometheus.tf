data "google_client_config" "provider" {}

data "google_container_cluster" "id-me-hello-world-app-k8s-cluster" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.region
}

# Deploy the kube-prometheus-stack Helm chart to simplify Prometheus/Grafana installation
resource "helm_release" "prometheus-deployment" {
  name       = "prometheus-deployment"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  values = [
    "${file("prometheus-values.yaml")}"
  ]
}
