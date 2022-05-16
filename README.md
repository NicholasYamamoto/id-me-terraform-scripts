# id-me-terraform-scripts

Terraform scripts for the ID.me take-home assignment.

As part of the assignment, I was tasked with deploying my web application to GCP using Terraform, so naturally for this I decided to utilize the Google Kubernetes Engine (GKE) that GCP provides to create and manage a Kubernetes Cluster in my cloud infrastructure.

This repository is broken up into four sections:
* [`/gke`](https://github.com/NicholasYamamoto/id-me-terraform-scripts/tree/master/gke)
    * Creates a VPC configured with a private subnet
    * Creates a GKE Cluster
    * Creates a Workload Identity service account for Kubernetes to use to interact from the cluster to thanye GCP resources
    * Creates Cloud Storage buckets to house each of the generated `.tfstate` files from each module

* [`/workload-identity`](https://github.com/NicholasYamamoto/id-me-terraform-scripts/tree/master/workload-identity)
    * Creates a Google Service Account and a Kubernetes Service Account
    * Creates an IAM policy to restrict the roles of the GSA
    * Binds the KSA to the GSA to allow it to "impersonate" it
* [`/web-app`](https://github.com/NicholasYamamoto/id-me-terraform-scripts/tree/master/web-app)
    * Creates a Deployment object containing
        * The **id-me-hello-world-app**
        * A CloudSQL Proxy sidecar to communicate with the CloudSQL instance
    * Creates Kubernetes secrets to manage database credentials and the `rails_secret_key_base` required by the app
* [`/monitoring`](https://github.com/NicholasYamamoto/id-me-terraform-scripts/tree/master/monitoring)
    * Deploys a Helm chart to create a Prometheus and Grafana deployment
    * Defines Prometheus rules to scrape the endpoints of nodes/pods/services in the cluster
    * Creates a link between the GCP infrastructure and a New Relic account to enable GCP resource and application monitoring

## The Monitoring Stack
For implementing the Monitoring stack for the GCP project and the GKE cluster, I decided to go with the current
industry standard and included a **Prometheus** system-level monitoring deployment with a **Grafana** dashboard
to give the metrics a nice visualization.

To take this a step further, I included a **New Relic** application-level monitoring implementation by creating a
New Relic-specific Service Account and linking it to my GCP project so I could provide monitoring for all the GCP
services. In my case, I chose to monitor:
* Kubernetes
* Load Balancing
* Router
* SQL
* Storage
* Virtual Machines
* VPC access

While my application is miniscule in scale, I felt it good to deploy a method to monitor and promote observability at both the Application-level as well as going a layer deeper into the System-level, and Prometheus and New Relic allow me to achieve that.

## Design Choices
As a first-time user of the Google Cloud Platform, I wanted to start off by following various best practices established by the GCP developers as well as the DevOps community. Some of the choices I made include:
* Implemented Workload Identity for all Kubernetes services that need to interact with a GCP resource
* Implemented the GKE cluster node pool to be Separately-managed, following GCP best practices
* Created a CI/CD pipeline to push Master branch builds as Docker Images to the GCP Artifact Registry
* Enabled and configured Auto-scaling of Cluster Nodes to promote Scalability
* Created individual Cloud Storage buckets to store the generated `.tfstate` files from each Terraform module securely
* Run a CloudSQL Proxy as a sidecar container for my app deployment

In addition to the design choices I made for the GCP infrastructure and the GKE cluster, I made some choices regarding the rest of the project as well:
* Opted to stray from the Terraform `module` structure as it
  * Prevents potential issues with maintaining the project's state
  * Makes the implementation easier to manage
  * Capitalizes on the principle of "Keep It Simple, Stupid" (KISS)
* Implemented a multi-stage build for the [id-me-hello-world-app](https://github.com/NicholasYamamoto/id-me-hello-world-app) in order to make the Docker Image (stored in the Artifact Registry) as small as possible
  * `NOTE:` I discovered a caveat to this. Docker [does not respect the `.dockerignore` file in a multi-stage build](https://forums.docker.com/t/dockerignore-in-multi-stage-builds/57169), as it will apply to the initial "Builder" stage, but not to any stages that proceed it. I found a hack-y solution to this, but [was not able to apply it to my use case](https://github.com/moby/moby/issues/33923#issuecomment-1120351433) as it requires `bash`, which I did not want to install in my Alpine-based Ruby image as it sort-of defeats the purpose of using the smallest available image possible by needing to include it and all its dependency packages