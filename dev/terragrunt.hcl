locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region      = local.env_vars.locals.defaults.region
  environment = local.env_vars.locals.defaults.environment
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "gcp00-tf-state-${local.environment}"
    project = "terraform-291518"
    prefix  = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project     = "terraform-291518"
  region      = "${local.region}"
}
EOF
}
