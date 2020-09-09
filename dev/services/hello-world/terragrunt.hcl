# Define base variables
# that will be used as inputs for infrastructure modules
locals {
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment  = local.env_vars.locals.defaults.environment
  region       = local.env_vars.locals.defaults.region
  project_tags = {
    Name = "hello-world"
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

# Sourcing hello-world module
terraform {
  source = "../../../../infrastructure-modules//services/hello-world"
}

# Define module dependencies
# Dependency module outputs will be used for
# current module inputs
# https://terragrunt.gruntwork.io/docs/getting-started/configuration/
dependency "ecs" {
  config_path = "../../platforms/ecs-cluster-00"
}

dependency "vpc" {
  config_path = "../../networking/vpc"
}

# hello-wolrd infrastructure module inputs
inputs = {
  region           = local.region
  name             = local.project_tags.Name
  family           = local.project_tags.Name
  cluster          = dependency.ecs.outputs.ecs_cluster_arn
  target_group_arn = dependency.ecs.outputs.target_group_arns.0
  security_groups  = [
    dependency.ecs.outputs.alb_sg_client_id
  ]
  vpc_id           = dependency.vpc.outputs.vpc_id
  subnets          = dependency.vpc.outputs.private_subnets
  container_image  = "nginx:stable-alpine"
  container_name   = local.project_tags.Name
  container_port   = 80
  tags             = local.tags
}
