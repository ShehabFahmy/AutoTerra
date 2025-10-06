output "lb_ip" {
  value = google_compute_global_address.lb_ip.address
}

output "backend_service" {
  value = google_compute_backend_service.lb_backend.self_link
}