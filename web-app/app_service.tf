# Creating a simple LoadBalancer service to expose the app to the internet
resource "kubernetes_service" "app-service" {
  metadata {
    name = "${var.app_name}-service"
    labels = {
      k8s_object = "id-me-hello-world-app-service"
    }
  }
  spec {
    selector = {
      k8s_object = "id-me-hello-world-app-deployment"
    }
    port {
      # Listening on port 3000 to match the Puma server port in the web app
      port        = 3000
      target_port = 3000
    }

    type             = "LoadBalancer"
    load_balancer_ip = var.load_balancer_ip
  }
}