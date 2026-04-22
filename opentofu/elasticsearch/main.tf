resource "google_cloud_run_v2_service" "elasticsearch" {
  name     = "elasticsearch-${var.region}"
  location = var.region
  launch_stage = "BETA"
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "elasticsearch:8.6.2"

      env {
        name  = "discovery.type"
        value = "single-node"
      }

      env {
        name  = "node.name"
        value = "elasticsearch-01"
      }

      env {
        name  = "bootstrap.memory_lock"
        value = "true"
      }

      env {
        name  = "ES_JAVA_OPTS"
        value = "-Xms512m -Xmx512m"
      }

      env {
        name  = "cluster.name"
        value = "es-wis2box"
      }

      env {
        name  = "xpack.security.enabled"
        value = "false"
      }

      env {
        name  = "ingest.geoip.downloader.enabled"
        value = "false"
      }

      env {
        name  = "xpack.ml.enabled"
        value = "false"
      }

      env {
        name  = "xpack.watcher.enabled"
        value = "false"
      }

      env {
        name  = "xpack.graph.enabled"
        value = "false"
      }

      env {
        name  = "xpack.monitoring.templates.enabled"
        value = "false"
      }

      env {
        name  = "cluster.routing.allocation.disk.threshold_enabled"
        value = "false"
      }

      resources {
        limits = {
          memory = "1536Mi"
          cpu    = "1"
        }
      }

      ports {
        container_port = 9200
      }

      volume_mounts {
        name = "elastic-data-volume"
        mount_path = "/usr/share/elasticsearch/data"
      }
    }

    volumes {
        name = "elastic-data-volume"
        empty_dir {
          medium = "DISK"
          size_limit = "10Gi"
        }
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    timeout = "300s"
  }

}

resource "google_cloud_run_v2_service_iam_member" "public_access" {
  location = google_cloud_run_v2_service.elasticsearch.location
  project  = google_cloud_run_v2_service.elasticsearch.project
  name     = google_cloud_run_v2_service.elasticsearch.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

variable "region" {
  description = "GCP region for Cloud Run deployment"
  type        = string  
}