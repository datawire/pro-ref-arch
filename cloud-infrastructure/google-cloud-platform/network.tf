resource "google_compute_network" "shop" {
  name                    = "shop"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "shop" {
  name    = "tf-shop-firewall"
  network = "${google_compute_network.shop.name}"

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "${var.shopfront_port}", "${var.productcatalogue_port}", "${var.stockmanager_port}"]
  }

  source_ranges = ["${var.all_locations_cidr}"]
}

resource "google_compute_http_health_check" "shopfront" {
  name                = "tf-shopfront-basic-check"
  request_path        = "/"
  port                = "${var.shopfront_port}"
  check_interval_sec  = 1
  healthy_threshold   = 1
  unhealthy_threshold = 10
  timeout_sec         = 1
}

resource "google_compute_target_pool" "shopfront" {
  name          = "tf-shopfront-target-pool"
  instances     = ["${google_compute_instance.vm_shopfront.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.shopfront.name}"]
}

resource "google_compute_forwarding_rule" "shopfront" {
  name       = "tf-shopfront-forwarding-rule"
  target     = "${google_compute_target_pool.shopfront.self_link}"
  port_range = "${var.shopfront_port}"
}

resource "google_compute_http_health_check" "productcatalogue" {
  name                = "tf-productcatalogue-check"
  request_path        = "/products"
  port                = "${var.productcatalogue_port}"
  check_interval_sec  = 1
  healthy_threshold   = 1
  unhealthy_threshold = 10
  timeout_sec         = 1
}

resource "google_compute_target_pool" "productcatalogue" {
  name          = "tf-productcatalogue-pool"
  instances     = ["${google_compute_instance.vm_productcatalogue.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.productcatalogue.name}"]
}

resource "google_compute_forwarding_rule" "productcatalogue" {
  name       = "tf-productcatalogue-forwarding-rule"
  target     = "${google_compute_target_pool.productcatalogue.self_link}"
  port_range = "${var.productcatalogue_port}"
}

resource "google_compute_http_health_check" "stockmanager" {
  name                = "tf-stockmanager-basic-check"
  request_path        = "/stocks"
  port                = "${var.stockmanager_port}"
  check_interval_sec  = 1
  healthy_threshold   = 1
  unhealthy_threshold = 10
  timeout_sec         = 1
}

resource "google_compute_target_pool" "stockmanager" {
  name          = "tf-stockmanager-target-pool"
  instances     = ["${google_compute_instance.vm_stockmanager.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.stockmanager.name}"]
}

resource "google_compute_forwarding_rule" "stockmanager" {
  name       = "tf-stockmanager-forwarding-rule"
  target     = "${google_compute_target_pool.stockmanager.self_link}"
  port_range = "${var.stockmanager_port}"
}
