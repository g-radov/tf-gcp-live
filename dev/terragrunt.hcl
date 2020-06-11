locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region = local.env.locals.defaults.region
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "lan0-tf-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "lan0-tf-dev"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
  assume_role {
    role_arn = "arn:aws:iam::657426360076:user/terragrunt"
  }
}
EOF
}
