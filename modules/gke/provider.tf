terraform {
  backend "gcs" {
    bucket = "id-me-hello-world-app-tfstate"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.20.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
