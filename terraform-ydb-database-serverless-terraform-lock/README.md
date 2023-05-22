```bash
/bin/bash /home/user/IdeaProjects/terraform-ydb-database-serverless/terraform_apply.sh

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Finding yandex-cloud/yandex versions matching "0.91.0"...
- Using previously-installed yandex-cloud/yandex v0.91.0
- Using previously-installed hashicorp/aws v4.67.0

Terraform has been successfully initialized!

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform planned the following actions, but then encountered a problem:

  # yandex_iam_service_account.ydb-sa will be created
  + resource "yandex_iam_service_account" "ydb-sa" {
      + created_at = (known after apply)
      + folder_id  = "b1g972v94kscfi3qmfmh"
      + id         = (known after apply)
      + name       = "sa-storage-admin"
    }

  # yandex_iam_service_account_static_access_key.ydb-sa-static-key will be created
  + resource "yandex_iam_service_account_static_access_key" "ydb-sa-static-key" {
      + access_key           = (known after apply)
      + created_at           = (known after apply)
      + description          = "static access key for object storage"
      + encrypted_secret_key = (known after apply)
      + id                   = (known after apply)
      + key_fingerprint      = (known after apply)
      + secret_key           = (sensitive value)
      + service_account_id   = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.ydb-sa-compute-admin will be created
  + resource "yandex_resourcemanager_folder_iam_member" "ydb-sa-compute-admin" {
      + folder_id = "b1g972v94kscfi3qmfmh"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "compute.admin"
    }

  # yandex_resourcemanager_folder_iam_member.ydb-sa-storage-admin will be created
  + resource "yandex_resourcemanager_folder_iam_member" "ydb-sa-storage-admin" {
      + folder_id = "b1g972v94kscfi3qmfmh"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "storage.admin"
    }

  # yandex_storage_bucket.ydb will be created
  + resource "yandex_storage_bucket" "ydb" {
      + access_key            = (known after apply)
      + acl                   = (known after apply)
      + bucket                = "ydb-backet-anton-patsev"
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = true
      + id                    = (known after apply)
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)
    }

  # yandex_ydb_database_serverless.sections will be created
  + resource "yandex_ydb_database_serverless" "sections" {
      + created_at            = (known after apply)
      + database_path         = (known after apply)
      + deletion_protection   = false
      + document_api_endpoint = (known after apply)
      + folder_id             = (known after apply)
      + id                    = (known after apply)
      + location_id           = (known after apply)
      + name                  = "sections"
      + status                = (known after apply)
      + tls_enabled           = (known after apply)
      + ydb_api_endpoint      = (known after apply)
      + ydb_full_endpoint     = (known after apply)
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + yandex_storage_bucket_ydb_access_key = (sensitive value)
  + yandex_storage_bucket_ydb_bucket     = (sensitive value)
  + yandex_storage_bucket_ydb_secret_key = (sensitive value)
╷
│ Error: configuring Terraform AWS Provider: no valid credential sources for Terraform AWS Provider found.
│ 
│ Please see https://registry.terraform.io/providers/hashicorp/aws
│ for more information about providing credentials.
│ 
│ AWS Error: failed to refresh cached credentials, no EC2 IMDS role found, operation error ec2imds: GetMetadata, access disabled to EC2 IMDS via client option, or "AWS_EC2_METADATA_DISABLED" environment variable
│ 
│ 
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on main.tf line 5, in provider "aws":
│    5: provider "aws" {
│ 
╵

```