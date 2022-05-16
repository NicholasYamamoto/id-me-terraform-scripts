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

variable "new_relic_service_account" {
  type        = string
  description = "The Service Account used by New Relic to monitor the GCP infrastructure"
}

variable "new_relic_account_id" {
  type        = string
  description = "My personal New Relic Account ID"
  sensitive   = true
}

variable "new_relic_user_api_key" {
  type        = string
  description = "The User API key for my New Relic account"
  sensitive   = true
}