output "newrelic_gcp_linked_account_name" {
  value       = newrelic_cloud_gcp_link_account.gcp-account.name
  description = "The name of the New Relic account linked to the GCP project"
}

output "newrelic_gcp_linked_account_id" {
  value       = newrelic_cloud_gcp_link_account.gcp-account.account_id
  description = "The account_id of the New Relic account linked to the GCP project"
}