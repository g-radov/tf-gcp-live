# Define base variables
# that will be used as inputs for infrastructure module
locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment = local.env_vars.locals.defaults.environment
  region      = local.env_vars.locals.defaults.region
  project_tags = {
    Name = "gcp00-vpc-${local.environment}"
  }
  tags = merge(
    local.env_vars.locals.defaults.tags,
    local.project_tags
  )
}

# terragrunt-specific function
# https://terragrunt.gruntwork.io/docs/reference/built-in-functions/#find_in_parent_folders
include {
  path = find_in_parent_folders()
}

# Sourcing 'vpc' infrastructure module
terraform {
  source = "../../../../tf-infrastructure-modules//gcp/networking/vpc"
}

# 'vpc' infrastructure module inputs
inputs = {
  region       = local.region
  project_id   = "example-project"
  network_name = local.project_tags.Name
  routing_mode = "GLOBAL"
  subnet_ip = [
    "10.10.0.0/16",
  ]
}
