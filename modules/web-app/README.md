# web-app

This module is used to deploy my id-me-hello-world-app from the Artifact Registry and allow it to communicate with
the CloudSQL instance I created.

It utilizes a few Official Terraform Providers to perform the following:
* Creates a Deployment object that contains two containers:
  * The **id-me-hello-world-app** pulled from the GCP Artifact Registry
  * A CloudSQL Proxy to allow the **id-me-hello-world-app** to connect to the GCP CloudSQL instance
* Deploys a Helm chart to create an Nginx ingress controller to make the Pods (and my app) accessible from the internet
