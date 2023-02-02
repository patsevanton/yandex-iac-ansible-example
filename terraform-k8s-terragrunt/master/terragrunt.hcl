
terraform {
  source = "github.com/patsevanton/terraform-yandex-kubernetes-cluster.git?ref=main"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_name             = "test"
  cluster_ipv4_range       = "10.0.0.0/16"
  service_ipv4_range       = "10.1.0.0/16"
  node_ipv4_cidr_mask_size = "25"
  version_k8s              = "1.23"
  zone                     = "ru-central1-b"
}
