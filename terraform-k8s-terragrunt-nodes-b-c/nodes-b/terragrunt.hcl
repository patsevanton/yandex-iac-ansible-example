terraform {
  source = "github.com/patsevanton/terraform-yandex-kubernetes-node-group.git//.?ref=main"
}

include {
  path = find_in_parent_folders()
}


dependency "master" {
  config_path = "../master"
}

inputs = {

  cluster_id  = dependency.master.outputs.cluster_id
  pool_name   = "test-node-b"
  k8s_version = "1.23"
  nat         = false
  num         = 1
  max_num     = 1
  cpu         = 4
  memory      = 8
  disk        = 100
  disk_type   = "network-ssd"
  k8s_zone    = ["ru-central1-b"]
  subnet_id   = [
    "e2l6251f60t5e6faq3o7", # ru-central1-b
  ]
}
