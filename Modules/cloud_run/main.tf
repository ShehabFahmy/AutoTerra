resource "google_cloud_run_service" "service" {
  name     = var.config.name
  project  = var.config.project_id
  location = var.config.location

  template {
    metadata {
      annotations = merge(
        var.config.annotations,
        var.config.vpc_connector == null ? {} : {
          "run.googleapis.com/vpc-access-connector" = var.config.vpc_connector
          "run.googleapis.com/vpc-access-egress"    = coalesce(var.config.egress, "all")
        },
        var.config.min_scale == null ? {} : { "autoscaling.knative.dev/minScale" = tostring(var.config.min_scale) },
        var.config.max_scale == null ? {} : { "autoscaling.knative.dev/maxScale" = tostring(var.config.max_scale) },
        var.config.ingress == null ? {} : { "run.googleapis.com/ingress" = var.config.ingress }
      )
    }
    spec {
      service_account_name  = var.config.service_account_email
      container_concurrency = var.config.container_concurrency
      timeout_seconds       = var.config.timeout_seconds
      containers {
        image = var.config.image

        dynamic "env" {
          for_each = var.config.env
          content {
            name  = env.key
            value = env.value
          }
        }

        ports {
          name           = "http1"
          container_port = var.config.container_port
        }

        command = var.config.command
        args    = var.config.args
      }
    }
  }

  autogenerate_revision_name = true
}

# Allow public access if enabled
resource "google_cloud_run_service_iam_member" "public_invoker" {
  count    = var.config.allow_unauthenticated ? 1 : 0
  project  = var.config.project_id
  location = var.config.location
  service  = google_cloud_run_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
