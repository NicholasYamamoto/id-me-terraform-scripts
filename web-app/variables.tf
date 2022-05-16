variable "app_image" {
  type        = string
  description = "The Docker Image used to build the application stored in Artifact Registry"
}

variable "app_name" {
  type        = string
  description = "The name of the application"
}

variable "gke_node_pool" {
  type        = string
  description = "The corresponding Node Pool in GKE"
}

variable "k8s_namespace" {
  type        = string
  description = "The namespace of the cluster"
}

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

variable "k8s_service_account" {
  type        = string
  description = "The name of the Kubernetes Service Account binded to a GSA"
}

variable "database_name" {
  type        = string
  description = "CloudSQL instance database name"
  sensitive   = true
}

variable "database_username" {
  type        = string
  description = "CloudSQL instance username"
  sensitive   = true
}

variable "database_password" {
  type        = string
  description = "CloudSQL instance password"
  sensitive   = true
}

variable "rails_secret_key_base" {
  type        = string
  description = "secret_key_base used for the Rails web app"
  sensitive   = true
}

variable "db_instance_connection_name" {
  type        = string
  description = "The full connection name for the CloudSQL instance"
  sensitive   = true
}