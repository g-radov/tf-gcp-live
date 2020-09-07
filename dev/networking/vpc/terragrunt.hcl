locals {
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment  = local.env_vars.locals.defaults.environment
  project_tags = {
    Name = "vpc-infra-lan0-${local.environment}"
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
  source = "../../../../infrastructure-modules//networking/vpc"
}

inputs = {
  name = local.project_tags.Name
  cidr = "10.0.0.0/16"
  azs  = [
    "eu-west-1a",
    "eu-west-1b",
    "eu-west-1c"
  ]
  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24", 
    "10.0.3.0/24"
  ]
  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
  tags = local.tags
}
