remote_state {
  backend = "local"
  config = {
    path = "${path_relative_to_include()}/terraform.tfstate"
  }
}

#remote_state {
#  backend = "s3"
#  config = {
#    bucket = "my-terraform-state"
#    key = "${path_relative_to_include()}/terraform.tfstate"
#    region         = "us-east-1"
#    encrypt        = true
#    dynamodb_table = "my-lock-table"
#  }
#}
