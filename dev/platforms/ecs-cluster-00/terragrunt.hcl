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

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../infrastructure-modules//platforms/ecs-fargate"
}

dependency "vpc" {
  config_path = "../../networking/vpc"
}

inputs = {
  name    = local.project_tags.Name
  vpc_id  = dependency.vpc.outputs.vpc_id
  subnets = dependency.vpc.outputs.public_subnets
  ingress_cidr_blocks = [
    "0.0.0.0/0"
  ]
  tags    = local.tags
}
