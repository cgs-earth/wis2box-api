provider "google" {
  project     = var.project
  region      = "us"
  credentials = file(var.credentials) 
}

resource "google_project_service" "required_apis" {
  for_each = toset([
    "run.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ])

  project = var.project
  service = each.key

  disable_on_destroy = false
}

module "storage" {
  depends_on = [google_project_service.required_apis]
  source = "./storage"
  region = var.region
  service_account_email = var.service_account_email
  s3_bucket = "${var.project}-wis2box"
}

module "elasticsearch" {
  depends_on = [google_project_service.required_apis]
  source = "./elasticsearch"
  region = var.region
}

module "wis2box-api" {
  depends_on = [google_project_service.required_apis]
  source = "./wis2box-api"
  region = var.region
  service_account_email = var.service_account_email
  url = var.url

  # S3 configuration for WIS2BOX API
  s3_storage_url = "https://storage.googleapis.com"
  s3_bucket_incoming = module.storage.s3_bucket_incoming
  s3_bucket_public = module.storage.s3_bucket_public
  s3_access_key = module.storage.s3_access_key
  s3_secret_key = module.storage.s3_secret_key

  # Backend configuration
  backend_url = module.elasticsearch.backend_url

}
