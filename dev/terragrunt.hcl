remote_state {
  backend = "s3"
  generate = {
    path      = "s3_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "my-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "tf-dev"
  }
}
