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

variable "k8s_service_account" {
  type        = string
  description = "The name of the Kubernetes Service Account binded to a GSA"
}

variable "k8s_namespace" {
  type        = string
  description = "The namespace of the cluster"
}