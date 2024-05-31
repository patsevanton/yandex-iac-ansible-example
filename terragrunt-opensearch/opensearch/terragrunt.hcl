terraform {
  source = "github.com/terraform-yacloud-modules/terraform-yandex-mdb-opensearch.git//.?ref=main"
}

inputs = {
  name = "test-opensearch"
  network_id = "xxx"
  folder_id  = "xxxx"
  maintenance_window_hour = 2
  maintenance_window_day  = "SUN"
  opensearch_nodes = {
    resources = {
      resource_preset_id = "s2.micro"
      disk_size          = 50
      disk_type_id       = "network-ssd"
    }
    hosts_count = 1
    zones_ids = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
    subnet_ids       = ["xxx"]
    assign_public_ip = false
    roles            = ["data", "manager"]
  }
}
