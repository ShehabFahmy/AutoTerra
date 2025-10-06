resource "google_compute_instance_group" "backend_group" {
  name        = var.instance_group_name
  project     = var.project_id
  zone        = var.instance_group_zone
  instances = var.instances

  named_port {
    name = "http"
    port = var.backend_port
  }
}

resource "google_compute_global_address" "lb_ip" {
  name    = "${var.lb_name}-ip"
  project = var.project_id
}

resource "google_compute_health_check" "lb_health" {
  name               = "${var.lb_name}-hc"
  project            = var.project_id
  check_interval_sec = 5
  timeout_sec        = 5

  http_health_check {
    port = var.health_check_port
  }
}

resource "google_compute_backend_service" "lb_backend" {
  name                  = "${var.lb_name}-backend"
  project               = var.project_id
  protocol              = var.protocol
  port_name             = "http"
  health_checks         = [google_compute_health_check.lb_health.self_link]
  load_balancing_scheme = var.internal ? "INTERNAL_MANAGED" : "EXTERNAL_MANAGED"

  backend {
    group = google_compute_instance_group.backend_group.self_link
  }
}

resource "google_compute_url_map" "lb_map" {
  name            = "${var.lb_name}-url-map"
  default_service = google_compute_backend_service.lb_backend.self_link
  project         = var.project_id
}

resource "google_compute_target_http_proxy" "lb_proxy" {
  name    = "${var.lb_name}-proxy"
  url_map = google_compute_url_map.lb_map.self_link
  project = var.project_id
}

resource "google_compute_global_forwarding_rule" "lb_rule" {
  name                  = "${var.lb_name}-fwd-rule"
  project               = var.project_id
  ip_address            = google_compute_global_address.lb_ip.address
  port_range            = var.frontend_port
  target                = google_compute_target_http_proxy.lb_proxy.self_link
  load_balancing_scheme = var.internal ? "INTERNAL_MANAGED" : "EXTERNAL_MANAGED"
}
