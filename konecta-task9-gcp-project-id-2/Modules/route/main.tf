resource "google_compute_route" "this" {
  name             = var.name
  network          = var.vpc_self_link
  dest_range       = var.dest_range
  next_hop_gateway = var.next_hop_gateway
  priority         = var.priority
  project          = var.project_id
}