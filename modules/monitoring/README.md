# monitoring


This module is used to deploy the Monitoring stack I decided to use

It uses the Kubernetes Provider to create the following:

* A Deployment object Pod that contains two containers:
  * The **hello-world-app** pulled from the GCP Artifact Registry
  * A CloudSQL Proxy to allow the **hello-world-app** to connect to the GCP CloudSQL instance
* A Service object that deploys a NGINX ingress controller (MAYBE)
*


It also contains