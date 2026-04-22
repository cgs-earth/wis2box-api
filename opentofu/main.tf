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

resource "google_cloud_run_v2_service" "wis2box_api" {
  depends_on = [google_project_service.required_apis]
  name                = "wis2box-api"
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
      image = "wmoim/wis2box-api:${var.image_tag}"
      ports {
        container_port = 80
      }

      command = ["/app/docker/entrypoint.sh"]
      env {
        name  = "WIS2BOX_API_URL"
        value = var.url
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
