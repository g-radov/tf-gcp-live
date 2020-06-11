terraform {
  source = "git@github.com:g-radov/tf-infra-modules.git//eks-luminor"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name = "bla"
}
