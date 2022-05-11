# Creating the Deployment object for my app and a CloudSQL Proxy to run as a sidecar container
resource "kubernetes_deployment" "id_me_hello_world_app_deployment" {
  metadata {
    name      = "id-me-hello-world-app-deployment"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "${var.app_name}"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.app_name}"
        }
      }

      spec {
        # id-me-hello-world-app container
        container {
          name  = var.app_name
          image = var.app_image
          port {
            name           = "puma-port"
            container_port = 3000
          }

          env {
            name = "DATABASE_NAME"
            value_from {
              secret_key_ref {
                name = "cloudsql-db-credentials"
                key  = "database"
              }
            }
          }

          env {
            name = "DATABASE_USERNAME"
            value_from {
              secret_key_ref {
                name = "cloudsql-db-credentials"
                key  = "username"
              }
            }
          }

          env {
            name = "DATABASE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "cloudsql-db-credentials"
                key  = "password"
              }
            }
          }

          env {
            name = "SECRET_KEY_BASE"
            value_from {
              secret_key_ref {
                name = "ruby-credentials"
                key  = "rails_secret_key_base"
              }
            }
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/health_check"
              port = "3000"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/health_check"
              port = "3000"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }
        }
        # cloud-sql-proxy sidecar container
        container {
          name    = "cloud-sql-proxy"
          image   = "gcr.io/cloudsql-docker/gce-proxy:latest"
          command = ["/cloud_sql_proxy", "-log_debug_stdout", "-instances=${var.db_instance_connection_name}=tcp:0.0.0.0:5432"]
          resources {
            limits = {
              cpu    = "500m"
              memory = "1Gi"
            }
            requests = {
              cpu    = "250m"
              memory = "500Mi"
            }
          }

          security_context {
            run_as_non_root = true
          }
        }

        node_selector = {
          "cloud.google.com/gke-nodepool" = "${var.gke_node_pool}"
        }

        #TODO: I think I need to replace this with the CloudSQL service account
        service_account_name = var.app_name
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = "1"
        max_surge       = "1"
      }
    }

    min_ready_seconds = 5
  }
}
