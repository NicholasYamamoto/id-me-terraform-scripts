# id-me-terraform-scripts

Terraform scripts for the ID.me take-home assignment.

As part of the assignment, I was tasked with deploying my web application to GCP using Terraform, so naturally for this I
decided to utilize the Google Kubernetes Engine (GKE) that GCP provides to create and manage a Kubernetes Cluster in my
cloud infrastructure.

This repository is broken up into three sections:
- **gke**
    - Creates a VPC
    - Creates a GKE Cluster
    - Creates a Workload Identity service account k8s to used
- **web-app**
    - Creates a Deployment object containing
        - The **id-me-hello-world-app**
        - A CloudSQL Proxy sidecar
    - Deploys a Helm chart to create an Nginx ingress controller
- **monitoring**
    - Deploys a Helm chart to create a Prometheus and Grafana deployment
