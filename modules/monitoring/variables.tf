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