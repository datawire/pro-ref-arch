provider "google" {
  project     = "${var.project_id}"
  region      = "${var.region}"
  zone        = "${var.region_zone}"
  credentials = "${file("${var.credentials_file_path}")}"
}
