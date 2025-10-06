resource "google_compute_firewall" "this" {
  name    = var.name
  network = var.vpc_self_link
  project = var.project_id

  allow {
    protocol = var.protocol
    ports    = var.ports
  }

  direction = "INGRESS"
  source_ranges = var.source_ranges
}
