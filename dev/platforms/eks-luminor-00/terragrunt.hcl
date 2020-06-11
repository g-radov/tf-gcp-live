locals {
  vars        = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment = local.vars.locals.defaults.environment
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:g-radov/tf-infra-modules.git//eks-luminor"
}

inputs = {
  environment = local.environment
  name        = "eks-luminor-00"
}
