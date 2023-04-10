resource "aws_ecs_cluster" "ecs_cluster" {
    name = "${local.project_name}-Cluster"
  
}
