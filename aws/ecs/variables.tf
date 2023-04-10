locals {
  project_name            = jsondecode(file("../../variables.json"))["project_name"]
  region                  = jsondecode(file("../../variables.json"))["region"]
  remote_state_bucket     = jsondecode(file("../../variables.json"))["terraform"]["remote_state_bucket"]
  remote_state_key_infra  = jsondecode(file("../../variables.json"))["terraform"]["remote_state_key_infra"]
  remote_state_key_elb    = jsondecode(file("../../variables.json"))["terraform"]["remote_state_key_elb"]
  domain_name             = jsondecode(file("../../variables.json"))["domain_name"]
  ecs_min_capacity        = jsondecode(file("../../variables.json"))["ecs"]["min_capacity"]
  ecs_desired_capacity    = jsondecode(file("../../variables.json"))["ecs"]["desired_capacity"]
  ecs_max_capacity        = jsondecode(file("../../variables.json"))["ecs"]["max_capacity"]
  ecs_container_port      = jsondecode(file("../../variables.json"))["ecs"]["container_port"]
}