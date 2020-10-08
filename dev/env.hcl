locals {
  defaults = {
    environment = "dev"
    region      = "europe-west1"
    tags = {
      Terraform   = "True"
      Environment = "dev"
    }
  }
}
