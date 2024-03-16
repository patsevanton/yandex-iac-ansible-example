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
  pool_name   = "test-node-a"
  k8s_version = "1.28"
  nat         = false
  num         = 1
  max_num     = 1
  cpu         = 4
  memory      = 8
  disk        = 100
  disk_type   = "network-ssd"
  k8s_zone    = ["ru-central1-a"]
  subnet_id = [
    "e9bca15oo9ji5vgnh8kv", # ru-central1-a
  ]
}
