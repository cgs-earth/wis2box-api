variable "service_account_email" {
  description = "Email of the service account to run the Cloud Run service"
  type        = string
}

variable "region" {
  description = "GCP region for Cloud Run deployment"
  type        = string
}

variable "url" {
  description = "Base URL for the WIS2BOX API (used in environment variable)"
  type        = string
}

# S3 bucket variables

variable "s3_storage_url" {
  description = "Base URL for S3 storage (used in environment variable)"
  type        = string
}

variable "s3_bucket_incoming" {
  description = "Name of the incoming S3 bucket (used in environment variable)"
  type        = string
}

variable "s3_bucket_public" {
  description = "Name of the public S3 bucket (used in environment variable)"
  type        = string
}

variable "s3_access_key" {
  description = "Access key for S3 storage (used in environment variable)"
  type        = string
}

variable "s3_secret_key" {
  description = "Secret key for S3 storage (used in environment variable)"
  type        = string
}

# Elasticsearch backend URL variable
variable "backend_url" {
  description = "URL for the WIS2BOX backend API (used in environment variable)"
  type        = string
}