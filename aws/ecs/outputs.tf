output "ecs_private_subnets" {
  value = data.terraform_remote_state.infra.outputs.private_subnets
}

output "ClusterName" {
  value = aws_ecs_cluster.ecs_cluster.name
  
}

output "ServiceName" {
  value = aws_ecs_service.ecs_service.name
}

resource "local_file" "ecr_name" {
  content  = aws_ecr_repository.ecs_registry.repository_url
  filename = "ecr_url.txt"
}