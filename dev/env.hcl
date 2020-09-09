locals {
  defaults = {
    environment = "dev"
    account_id  = "${get_aws_account_id()}"
    region      = "eu-west-1"
    tags = {
      Terraform   = "True"
      Environment = "dev"
    }
  }
}
