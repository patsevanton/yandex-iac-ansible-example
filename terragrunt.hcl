locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = merge({

  cloud_id   = local.env_vars.locals.cloud_id
  #  subnet_ids  = local.env_vars.locals.subnet_ids
  network_id = local.env_vars.locals.network_id
  folder_id  = local.env_vars.locals.folder_id

})
