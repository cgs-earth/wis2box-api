# variables.tf - Variables for WIS2BOX API OpenTofu deployment
variable "project" {
  description = "GCP project ID for deployment"
  type        = string
  default    = "iow-ucar"
}

variable "credentials" {
  description = "Path to GCP credentials JSON file"
  type        = string
}

variable "url" {
  description = "Base URL for the WIS2BOX API (used in environment variable)"
  type        = string
}

variable "service_account_email" {
  description = "Email of the service account to run the Cloud Run service"
  type        = string
}

variable "region" {
  description = "GCP region for Cloud Run deployment"
  type        = string
  default     = "africa-south1"
  validation {
    condition = contains([
      "us-central1", "us-east1", "us-east4", "us-west1", "us-west2", "us-west3", "us-west4",
      "europe-west1", "europe-west2", "europe-west3", "europe-west4", "europe-west6",
      "asia-east1", "asia-southeast1", "asia-northeast1", "africa-south1"
    ], var.region)
    error_message = "Region must be a valid GCP region that supports Cloud Run."
  }
}

variable "image_tag" {
  description = "Docker image tag for WIS2BOX API"
  type        = string
  default     = "latest"
}

