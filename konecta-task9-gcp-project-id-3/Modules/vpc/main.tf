resource "google_compute_network" "this" {
  name                    = var.name
  auto_create_subnetworks = false
  project                 = var.project_id
}
