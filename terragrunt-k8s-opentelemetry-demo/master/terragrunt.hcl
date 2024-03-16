
terraform {
  source = "github.com/patsevanton/terraform-yandex-kubernetes-cluster.git//.?ref=main"
}

include "root" {
  path = "${get_path_to_repo_root()}/terragrunt.hcl"
}

inputs = {
  cluster_name             = "test"
  cluster_ipv4_range       = "10.0.0.0/16"
  service_ipv4_range       = "10.1.0.0/16"
  node_ipv4_cidr_mask_size = "25"
  version_k8s              = "1.23"
  cluster_type             = "regional"
}
