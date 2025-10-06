output "service_name" {
  description = "Cloud Run service name"
  value       = google_cloud_run_service.service.name
}

output "service_url" {
  description = "Deployed Cloud Run service URL"
  value       = google_cloud_run_service.service.status[0].url
}

output "service_id" {
  description = "Cloud Run service ID"
  value       = google_cloud_run_service.service.id
}
