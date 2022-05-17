# gke

This module provisions, configures, and deploys a GKE cluster.

It utilizes a few Official Terraform Providers to perform the following:
* Creates a new VPC configured to use a private subnet to allocate external IP addresses to my Pods and Services
* Creates a `google_container_cluster` to provision the GKE cluster that my web app and Monitoring stack will deploy to
* Configures the cluster to be **Regional** to promote **High Availability**
* Creates a `google_container_node_pool` as a **Separately-managed Node Pool** to follow GCP best practices
* Creates a Google Service Account and binds a Kubernetes Service Account to it to utilize Workload Identity Federation
* Creates individual Cloud Storage buckets for each Terraform module to securely store their generated `.tfstate` files in
