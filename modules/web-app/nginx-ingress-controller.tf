# Deploy a Helm chart to create and configure an Nginx ingress controller for the cluster
resource "helm_release" "nginx-ingress-controller" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.1.1"
  values = [
    "${file("values.yaml")}"
  ]
}