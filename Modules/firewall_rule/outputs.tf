output "firewall_self_link" {
  description = "The self link of the firewall rule"
  value       = google_compute_firewall.this.self_link
}
