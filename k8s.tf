data "google_client_config" "current" {}

resource "google_container_cluster" "primary" {
  name     = "tf-gke"
  project  = var.project_id
  location = var.zone

  remove_default_node_pool = true
  min_master_version       = var.node_version
  initial_node_count = 1

  provider = "google-beta"

  monitoring_service = "none"

  addons_config {
    http_load_balancing {
      disabled = true
    }
    network_policy_config {
      disabled = false
    }
    istio_config {
      disabled = true
    }
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  depends_on = [
    google_service_account.least-privilege-sa-for-gke,
  ]
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name     = "node-pool-for-tf-gke"
  cluster  = google_container_cluster.primary.name
  project  = google_container_cluster.primary.project
  location = google_container_cluster.primary.location

  node_count = 3

  node_config {
    preemptible     = true
    machine_type    = "e2-medium"
    service_account = "least-privilege-sa-for-gke@${var.project_id}.iam.gserviceaccount.com"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags = ["istio"]
  }

  depends_on = [
    google_service_account.least-privilege-sa-for-gke,
  ]
}
