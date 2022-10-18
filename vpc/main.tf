module "vpc" {
  source    = "github.com/darzanebor/terraform-yandex-vpc.git"
  name      = "my-vpc"
  folder_id = "b1g972v94kscfi3qmfmh"

  vpc_labels = {
    env = "production"
  }

  vpc_subnets = [
    {
      v4_cidr_blocks = ["10.2.0.0/16"]
      zone           = "ru-central1-a"
      labels = {
        type = "default-subnet"
      }
      dhcp_options   = {
        domain_name = null
        domain_name_servers = ["8.8.8.8", "8.8.8.8"]
        ntp_servers = ["8.8.8.8", "8.8.8.8"]
      }
    },
  ]

}