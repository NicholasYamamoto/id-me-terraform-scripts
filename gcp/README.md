# gcp

This module is used to perform two tasks necessary after the GCP infrastructure and VPC have been created. 

First, it creates the individual Cloud Storage buckets to store the generated `.tfstate` files from each module in a secure location, following the GCP best practices. 

Second, it establishes Workload Identity Federation by creating a Kubernetes Service Account (KSA) and a Google Service Account (GSA) and binding the two together, allowing the KSA to "impersonate" the GSA as a Workload Identity User.

The benefits of implementing **Workload Identity Federation** includes the ability to **control exactly how much access a third-party service has to the GCP project, the GKE cluster, and any resources that it includes** by "confining" the KSA strictly into only the roles that it absolutely needs in order to perform its functions.

It also **eliminates the need to create (and more importantly, securely maintain) a traditional Service Account Key**. Service Account Keys are, by nature, long-life and are meant to be persistent, introducing a potential attack vector should it be compromised. Again, Workload Identity Federation helps with this as accounts are created with the intention of their access to be short-lived, purely only for the tasks they must complete.

These are the reasons why GCP considers its usage a [best practice](https://cloud.google.com/iam/docs/workload-identity-federation#why).

The module utilizes the official Kubernetes and Google Terraform Providers to perform the following:
* Create individual Cloud Storage buckets to store the `.tfstate` files for each module
* Create a Google Service Account and assigns only the roles necessary to perform its functions to it
* Create an IAM policy to establish the KSA as a Workload Identity User (enabling Workload Identity Federation)
* Create a Kubernetes Service Account and binds the GSA to it to allow it to "impersonate" the GSA to perform its required tasks on the GCP resources it needs
