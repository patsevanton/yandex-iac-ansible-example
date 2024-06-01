terraform {
  source = "github.com/terraform-yacloud-modules/terraform-yandex-mdb-opensearch.git//.?ref=main"
}

inputs = {
  name                        = "test-opensearch"
  environment                 = "PRESTABLE"
  network_id                  = "xxx"
  folder_id                   = "xxxx"
  generate_admin_password     = false
  admin_password              = "super-password"

  opensearch_nodes = {
    group0 = {
      resources = {
        resource_preset_id = "s2.micro"
        disk_size          = "10737418240"
        disk_type_id       = "network-ssd"
      }
      hosts_count      = 1
      zones_ids        = ["ru-central1-a"]
      subnet_ids       = ["xxxx"]
      assign_public_ip = true
      roles            = ["data", "manager"]
    }
  }

  dashboard_nodes             = {}

  maintenance_window_type     = "WEEKLY"
  maintenance_window_hour     = 2
  maintenance_window_day      = "SUN"
}
