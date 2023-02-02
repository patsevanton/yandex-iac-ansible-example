locals {
  env_vars   = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = merge({
  
  subnet_id        = local.group_vars.locals.subnet_id
  network_id       = local.env_vars.locals.network_id
  folder_id        = local.env_vars.locals.folder_id

})
