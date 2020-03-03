variable "region" {
  default = "us-central1"
}

variable "region_zone" {
  default = "us-central1-f"
}

variable "credentials_file_path" {
  default = "~/.config/gcloud/datawireio-eababf109e7e.json"
}

variable "all_locations_cidr" {
  description = "Indicates access from/to all network sources/targets"
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  default = "n1-standard-1"
}

variable "instance_image" {
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "shopfront_count" {
  description = "Shopfront instance count"
  default     = "1"
}

variable "productcatalogue_count" {
  description = "Productcatalogue instance count"
  default     = "1"
}

variable "stockmanager_count" {
  description = "Stockmanager instance count"
  default     = "1"
}

variable "k8s_node_count" {
  description = "Kubernetes node pool instance count"
  default     = "3"
}

variable "shopfront_port" {
  default = "80"
}

variable "productcatalogue_port" {
  default = "8020"
}

variable "stockmanager_port" {
  default = "8030"
}

variable "shopfront_install_script_src_path" {
  description = "Path to the shopfront install script within this repo"
  default     = "scripts/shopfront_install.sh"
}

variable "productcatalogue_install_script_src_path" {
  description = "Path to the productcatalogue install script within this repo"
  default     = "scripts/productcatalogue_install.sh"
}

variable "stockmanager_install_script_src_path" {
  description = "Path to the stockmanager install script within this repo"
  default     = "scripts/stockmanager_install.sh"
}

variable "install_script_dest_path" {
  description = "Path to put the install script on each destination resource"
  default     = "/tmp/install.sh"
}

variable "spring_cfg_filename" {
  description = "Name of the Spring configuration file"
  default     = "application-override.properties"
}

variable "internet_accessible_tag" {
  description = "Used to indicate the instance should be accessible via the web"
  default     = "internet-accessible"
}
