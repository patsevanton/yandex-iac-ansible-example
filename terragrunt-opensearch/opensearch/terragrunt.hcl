terraform {
  source = "github.com/terraform-yacloud-modules/terraform-yandex-mdb-opensearch.git//.?ref=main"
}

inputs = {
  name = "test-opensearch"
  maintenance_window_hour = 2
  maintenance_window_day  = "SUN"
}
