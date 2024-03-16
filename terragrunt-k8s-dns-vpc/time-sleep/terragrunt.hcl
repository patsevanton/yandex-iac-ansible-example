terraform {
  source = "github.com/patsevanton/terraform-time-sleep.git//.?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc-address" {
  config_path = "../vpc-address"
}

inputs = {
  create_duration  = "10s"
  destroy_duration = "10s"
}
