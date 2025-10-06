resource "google_compute_subnetwork" "this" {
  name          = var.name
  ip_cidr_range = var.cidr
  region        = var.region
  network       = var.vpc_self_link
  project       = var.project_id
}
