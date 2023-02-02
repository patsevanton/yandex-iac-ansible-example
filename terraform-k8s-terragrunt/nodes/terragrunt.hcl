terraform {
  source = 
}

include {
  path = find_in_parent_folders()
}


dependency "masters" {
  config_path = "../masters"
}

inputs = {

  cluster_id  = dependency.masters.outputs.cluster_id
  pool_name   = ""
  k8s_version = "1.23"
  nat         = false
  num         = 3
  max_num     = 8
  cpu         = 2
  memory      = 8
  disk        = 100
  disk_type   = "network-ssd"
  k8s_zone    = ["ru-central1-b"]
  subnet_id   = []

}
