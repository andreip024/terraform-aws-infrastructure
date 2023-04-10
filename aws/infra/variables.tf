locals {
  project_name            = jsondecode(file("../../variables.json"))["project_name"]
  region                  = jsondecode(file("../../variables.json"))["region"]
  remote_state_bucket     = jsondecode(file("../../variables.json"))["terraform"]["remote_state_bucket"]
  remote_state_key_infra  = jsondecode(file("../../variables.json"))["terraform"]["remote_state_key_infra"]
  vpc_cidr                = jsondecode(file("../../variables.json"))["vpc_cidr"]
}