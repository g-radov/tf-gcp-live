# Define base variables
# that will be used as inputs for infrastructure module
locals {
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment  = local.env_vars.locals.defaults.environment
  project_tags = {
    Name = "ecs-cluster-00-${local.environment}"
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

# Sourcing ecs-fargate infrastructure module
terraform {
  source = "../../../../infrastructure-modules//platforms/ecs-fargate"
}

# Define module dependencies
# Dependency module outputs will be used for
# current module inputs
# https://terragrunt.gruntwork.io/docs/getting-started/configuration/
dependency "vpc" {
  config_path = "../../networking/vpc"
}

# ecs-fargate infrastructure module inputs
inputs = {
  name    = local.project_tags.Name
  vpc_id  = dependency.vpc.outputs.vpc_id
  subnets = dependency.vpc.outputs.public_subnets
  ingress_cidr_blocks = [
    "0.0.0.0/0"
  ]
  tags    = local.tags
}
