output "shop_loadbalancer_ip_port" {
  value = "${google_compute_forwarding_rule.shopfront.ip_address}:${var.shopfront_port}"
}

output "shopfront_ips" {
  value = "${join(" ", google_compute_instance.vm_shopfront.*.network_interface.0.access_config.0.nat_ip)}"
}
#
# output "productcatalogue_ips" {
#   value = "${join(" ", google_compute_instance.vm_productcatalogue.*.network_interface.0.access_config.0.nat_ip)}"
# }
#
# output "stockmanager_ips" {
#   value = "${join(" ", google_compute_instance.vm_stockmanager.*.network_interface.0.access_config.0.nat_ip)}"
# }

# output "k8s_master_ip" {
#   value = "${google_container_cluster.ambassador_demo.endpoint}"
# }

output "gcloud_get_creds" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.ambassador_demo.name} --project ${var.project_id} --zone ${var.region_zone}"
}

locals {
  shopfront_ambassador_cfg = <<SFAMBCFG

---
apiVersion: v1
kind: Service
metadata:
  name: shopfront
  annotations:
    getambassador.io/config: |
      ---
      apiVersion: ambassador/v1
      kind:  Mapping
      name:  shopfront_mapping
      prefix: /shopfront/
      service: ${google_compute_forwarding_rule.shopfront.ip_address}:${var.shopfront_port}
spec:
  ports:
  - name: shopfront
    port: 80
SFAMBCFG
}

output "shopfront_ambassador_config" {
  value = "${local.shopfront_ambassador_cfg}"
}
