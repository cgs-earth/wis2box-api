resource "google_storage_bucket" "incoming_bucket" {
  name          = "${var.s3_bucket}-incoming"
  location      = var.region
  
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }
}

resource "google_storage_bucket" "public_bucket" {
  name          = "${var.s3_bucket}-public"
  location      = var.region
  
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }
}

resource "google_storage_bucket_iam_member" "incoming_access" {
  bucket = google_storage_bucket.incoming_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_storage_bucket_iam_member" "public" {
  bucket = google_storage_bucket.public_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_hmac_key" "hmac_key" {
  service_account_email = var.service_account_email
}


variable "s3_bucket" {
  description = "Base name for the GCS buckets (without -incoming or -public suffix)"
  type        = string
}

variable "region" {
  description = "GCP region for Cloud Run deployment"
  type        = string  
}

variable "service_account_email" {
  description = "Email of the service account to run the Cloud Run service"
  type        = string
}
