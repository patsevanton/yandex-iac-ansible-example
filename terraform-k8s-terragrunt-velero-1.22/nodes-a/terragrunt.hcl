terraform {
  source = "github.com/patsevanton/terraform-yandex-kubernetes-node-group.git//.?ref=main"
}

include {
  path = find_in_parent_folders()
}


dependency "master" {
  config_path                             = "../master"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    cluster_id = "fake_cluster_id"
  }
}

inputs = {

  cluster_id  = dependency.master.outputs.cluster_id
  pool_name   = "test-node-a"
  k8s_version = "1.22"
  nat         = false
  num         = 2
  max_num     = 2
  cpu         = 4
  memory      = 8
  disk        = 50
  disk_type   = "network-ssd"
  k8s_zone    = ["ru-central1-a"]
  subnet_id = [
    "e9bca15oo9ji5vgnh8kv", # ru-central1-a
  ]
}
