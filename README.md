# id-me-terraform-scripts

Terraform scripts for the ID.me take-home assignment.

As part of the assignment, I was tasked with deploying my web application to GCP using Terraform, so naturally for this I
decided to utilize the Google Kubernetes Engine (GKE) that GCP provides to create and manage a Kubernetes Cluster in my
cloud infrastructure.

This repository is broken up into four sections:
- **gke**
    - Creates a VPC configured with a private subnet
    - Creates a GKE Cluster
    - Creates a Workload Identity service account for Kubernetes to use to interact from the cluster to thanye GCP resources
- **workload-identity**
    - Establishes Workload Identity Federation for the cluster by
      - Creating a Google Service Account and a Kubernetes Service Account
      - Creating an IAM policy to restrict the roles of the GSA
      - Binds the KSA to the GSA to allow it to "impersonate" it
- **web-app**
    - Creates a Deployment object containing
        - The **id-me-hello-world-app**
        - A CloudSQL Proxy sidecar to communicate with the CloudSQL instance
    - Creates Kubernetes secrets to manage database credentials and the `rails_secret_key_base` required by the app
- **monitoring**
    - Deploys a Helm chart to create a Prometheus and Grafana deployment
    - Defines Prometheus rules to scrape the endpoints of nodes/pods/services in the cluster
    - Creates a link between the GCP infrastructure and a New Relic account to enable GCP resource and application monitoring
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

* Implemented a multi-stage Docker build to cut the final image size in half

* Run a CloudSQL Proxy as a sidecar container for my app deployment
