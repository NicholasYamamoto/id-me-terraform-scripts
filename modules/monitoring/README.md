# monitoring

This module is used to deploy the Monitoring stack I decided to use to observe the Nginx ingress controller
as well as the overall System-level health of components within the cluster.

* Implements New Relic Application Monitoring by
  * Creating a New Relic Service Account
  * Granting access to roles required by for the New Relic integration
  * Linking my New Relic account to the GCP project to enable monitoring for various GCP services
