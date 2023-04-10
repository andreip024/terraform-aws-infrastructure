
variable "github_oauth_token" {}

locals {
    project_name            = jsondecode(file("../../variables.json"))["project_name"]
    region                  = jsondecode(file("../../variables.json"))["region"]
    remote_state_bucket     = jsondecode(file("../../variables.json"))["terraform"]["remote_state_bucket"]
    remote_state_key_infra  = jsondecode(file("../../variables.json"))["terraform"]["remote_state_key_infra"]
    remote_state_key_ecs    = jsondecode(file("../../variables.json"))["terraform"]["remote_state_key_ecs"]
    ci_project_url          = jsondecode(file("../../variables.json"))["docker_app"]["ci_project_url"]
    ci_project_name         = jsondecode(file("../../variables.json"))["docker_app"]["ci_project_name"]
    ci_project_user         = jsondecode(file("../../variables.json"))["docker_app"]["ci_project_user"]
    pipeline_buket          = jsondecode(file("../../variables.json"))["pipeline_buket"]
}