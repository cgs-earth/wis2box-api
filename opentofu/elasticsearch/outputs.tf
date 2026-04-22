output "backend_url" {
  description = "URL of the deployed Elastic Cloud Run service"
  value       = google_cloud_run_v2_service.elasticsearch.uri
}