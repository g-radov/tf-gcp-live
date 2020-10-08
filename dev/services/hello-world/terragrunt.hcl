# Define base variables
# that will be used as inputs for infrastructure module
locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment = local.env_vars.locals.defaults.environment
  region      = local.env_vars.locals.defaults.region
  project_tags = {
    Name = "gke00-${local.environment}"
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

# Source 'hello-world' infrastructure module
terraform {
  source = "../../../../tf-infrastructure-modules//gcp/services/hello-world"
}

dependency "vpc" {
  config_path = "../../networking/vpc"
}

# 'hello-world' infrastructure module inputs
inputs = {
  project_id        = "example-project"
  name              = local.project_tags.Name
  region            = local.region
  network           = dependency.vpc.outputs.network_name
  subnetwork        = dependency.vpc.outputs.subnets_names.0
  ip_range_pods     = dependency.vpc.outputs.subnets_secondary_ranges[0][0].range_name
  ip_range_services = dependency.vpc.outputs.subnets_secondary_ranges[0][0].range_name
  zones = [
    "${local.region}-b",
  ]
}
