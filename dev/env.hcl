locals {
  defaults = {
    environment = "dev"
    region      = "eu-west-1"
    tags = {
      Terraform   = "True"
      Environment = "dev"
    }
  }
}
