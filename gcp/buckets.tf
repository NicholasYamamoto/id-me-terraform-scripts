# Creating Cloud Storage buckets to securely store the .tfstate files of each module
# Creating gke bucket
resource "google_storage_bucket" "gke-bucket" {
  name          = "gke-tfstate-bucket"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Creating gcp bucket
resource "google_storage_bucket" "gcp-bucket" {
  name          = "gcp-config-tfstate-bucket"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Creating web-app bucket
resource "google_storage_bucket" "web-app-bucket" {
  name          = "web-app-tfstate-bucket"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Creating monitoring bucket
resource "google_storage_bucket" "monitoring-bucket" {
  name          = "monitoring-tfstate-bucket"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}