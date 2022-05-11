variable "project_id" {
  type        = string
  description = "The GCP project ID to use for this Terraform plan"
}

variable "region" {
  type        = string
  description = "The GCP region to deploy the cluster to"
}

variable "cluster_name" {
  type        = string
  description = "The name given to the cluster"
}

variable "app_name" {
  type        = string
  description = "The name of the application"
}

variable "namespace" {
  type        = string
  description = "The namespace of the cluster"
}

variable "machine_type" {
  type        = string
  description = "The VM machine type to use"
}

variable "gke_node_pool" {
  type        = string
  description = "The corresponding Node Pool in GKE"
}
