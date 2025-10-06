output "self_link" {
  value = local.is_regional ? google_compute_address.ip_regional[0].self_link : google_compute_global_address.ip_global[0].self_link
}
