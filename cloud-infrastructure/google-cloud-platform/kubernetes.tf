resource "google_container_cluster" "ambassador_demo" {
  name               = "ambassador-demo"
  network = "${google_compute_network.shop.name}"

  min_master_version = "latest"

  remove_default_node_pool = true
  initial_node_count = 1

  ip_allocation_policy {
     use_ip_aliases = true
  }

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "ambassador_preemptible_nodes" {
  name       = "ambassador-demo-node-pool"
  cluster    = "${google_container_cluster.ambassador_demo.name}"
  node_count = "${var.k8s_node_count}"

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
