resource "google_compute_firewall" "rule-for-istio" {
  name    = "allow-connections-for-istio"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "10250", "15017"]
  }
  target_tags = ["istio"]
}

resource "google_compute_firewall" "rule-for-iap" {
  name    = "allow-iap-forwarding-ssh"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}