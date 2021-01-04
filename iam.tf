resource "google_service_account" "least-privilege-sa-for-gke" {
  project    = var.project_id
  account_id = "least-privilege-sa-for-gke"
}

resource "google_project_iam_member" "gke_node_pool_roles" {
  project = var.project_id
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/storage.objectViewer"
  ])
  role   = each.value
  member = "serviceAccount:${google_service_account.least-privilege-sa-for-gke.email}"
}
