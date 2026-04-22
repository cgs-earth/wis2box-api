# outputs.tf - Outputs from WIS2BOX API OpenTofu deployment

output "service_url" {
  description = "URL of the deployed WIS2BOX API Cloud Run service"
  value       = google_cloud_run_v2_service.wis2box_api.uri
}

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_v2_service.wis2box_api.name
}

output "service_location" {
  description = "Location of the Cloud Run service"
  value       = google_cloud_run_v2_service.wis2box_api.location
}

output "service_id" {
  description = "Unique identifier of the Cloud Run service"
  value       = google_cloud_run_v2_service.wis2box_api.id
}

output "api_endpoints" {
  description = "Important API endpoints"
  value = {
    base_url     = google_cloud_run_v2_service.wis2box_api.uri
  }
}
