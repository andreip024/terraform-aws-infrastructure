resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                    = "${local.project_name}-TD-Family"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = 256
  memory                    = 512
  network_mode              = "awsvpc"
  execution_role_arn        = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn             = aws_iam_role.ecs_task_execution_role.arn
  container_definitions     = jsonencode([
    {
      name            = "${local.project_name}-Container"
      image           = "${aws_ecr_repository.ecs_registry.repository_url}:latest"
#     cpu             = 10
#     memory          = 512
      essential       = true
      portMappings    = [
       {
         containerPort = local.ecs_container_port
         hostPort      = local.ecs_container_port
         }
     ]
      logConfiguration = {
          logDriver    = "awslogs",
          options      = {
            awslogs-group         = data.terraform_remote_state.infra.outputs.cloudwach_group
            awslogs-region        = local.region
            awslogs-stream-prefix = "ecs"
          }
        }
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

}
