# Deploy the kube-prometheus-stack Helm chart to simplify Prometheus/Grafana installation
resource "helm_release" "prometheus-deployment" {
  name       = "prometheus-deployment"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  values = [
    "${file("prometheus-values.yaml")}"
  ]
}