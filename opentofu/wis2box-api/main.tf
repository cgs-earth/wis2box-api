resource "google_cloud_run_v2_service" "wis2box_api" {
  name                = "wis2box-api-${var.region}"
  location            = var.region
  deletion_protection = false

  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = var.service_account_email
    scaling {
      max_instance_count = 2
      min_instance_count = 1
    }

    containers {
      image = "wmoim/wis2box-api:latest"
    #   image = "us-central1-docker.pkg.dev/iow-ucar/cloud-run-source-deploy/wis2box-api/wis2box-api@sha256:1e7797ce1801cd08019963eed78b7c1b28cd4f21dc4ca3356b8fcff1b2adfbf8"
      ports {
        container_port = 80
      }

      command = ["/app/docker/entrypoint.sh"]
      env {
        name  = "WIS2BOX_API_URL"
        value = "${var.url}/oapi"
      }
      env {
        name  = "WIS2BOX_API_BACKEND_URL"
        value = var.backend_url
      }
      env {
        name  = "WIS2BOX_LOGGING_LOGLEVEL"
        value = "ERROR"
      }
      env {
        name  = "WIS2BOX_BASEMAP_URL"
        value = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
      }
      env {
        name  = "WIS2BOX_BASEMAP_ATTRIBUTION"
        value = "&copy; <a href=\"https://openstreetmap.org/copyright\">OpenStreetMap contributors</a>"
      }

      env {
        name  = "WIS2BOX_STORAGE_SOURCE"
        value = var.s3_storage_url
      }
      env {
        name  = "WIS2BOX_STORAGE_INCOMING"
        value = var.s3_bucket_incoming
      }
      env {
        name  = "WIS2BOX_STORAGE_PUBLIC"
        value = var.s3_bucket_public
      }
      env {
        name  = "WIS2BOX_STORAGE_USER"
        value = var.s3_access_key
      }
      env {
        name  = "WIS2BOX_STORAGE_PASSWORD"
        value = var.s3_secret_key
      }

      resources {
        limits = {
          cpu    = "2"
          memory = "2Gi"
        }
        cpu_idle = false
      }
    }
  }

  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
}

resource "google_cloud_run_v2_service_iam_member" "public_access" {
  location = google_cloud_run_v2_service.wis2box_api.location
  project  = google_cloud_run_v2_service.wis2box_api.project
  name     = google_cloud_run_v2_service.wis2box_api.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

