module "folder" {
  source  = "git::https://github.com/dtoch56/terraform-yandex-folder.git?ref=v0.0.1"

  cloud_id    = var.yc_cloud_id
  folder_name = "my-folder"
}

module "bucket" {
  source = "github.com/darzanebor/terraform-yandex-s3-bucket.git"
  name   = "my-bucket"

  folder_id = module.folder.folder_id

  versioning = true

  max_size = 10737418240

  anonymous_access_flags = {
    read = false
    list = false
  }
}
