# web-app

This module is used to deploy my id-me-hello-world-app from the Artifact Registry and allow it to communicate with
the Postgres-based CloudSQL instance that I created.

It follows the [current GCP best practice](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine#run_the_as_a_sidecar) of deploying the CloudSQL Proxy (used to connect and access the CloudSQL instance) as a Proxy Sidecar container that accompanies the app in the same pod.

It utilizes a few Official Terraform Providers to perform the following:
* Creates a Deployment object that contains two containers:
  * The **id-me-hello-world-app** pulled from the latest Docker Image version available in the GCP Artifact Registry
  * A CloudSQL Proxy to allow the **id-me-hello-world-app** to connect to the GCP CloudSQL instance
* Creates Kubernetes Secrets to store the database credentials as well as the `rails_secret_key_base` required for my Ruby on Rails-based app to connect to the database in Production
