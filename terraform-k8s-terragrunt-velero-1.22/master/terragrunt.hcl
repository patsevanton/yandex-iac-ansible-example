
terraform {
  source = "github.com/patsevanton/terraform-yandex-kubernetes-cluster.git//.?ref=main"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_name             = "test-1-22"
  cluster_ipv4_range       = "10.2.0.0/22"
  service_ipv4_range       = "10.3.0.0/24"
  node_ipv4_cidr_mask_size = "26"
  version_k8s              = "1.22"
  cluster_type             = "regional"
}
