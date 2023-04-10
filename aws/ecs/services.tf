resource "aws_ecs_service" "ecs_service" {
    name            = "${local.project_name}-Service"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.ecs_task_definition.arn
    desired_count   = local.ecs_desired_capacity
    launch_type     = "FARGATE"

    network_configuration {
        subnets           = data.terraform_remote_state.infra.outputs.private_subnets
        assign_public_ip  = false
        security_groups   = [ data.terraform_remote_state.infra.outputs.sg ]
    }

    load_balancer {
        target_group_arn  = data.terraform_remote_state.elb.outputs.targetgroup_arn
        container_name    = "${local.project_name}-Container"
        container_port    = local.ecs_container_port
 }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = local.ecs_max_capacity
  min_capacity       = local.ecs_min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "${local.project_name}-ECS-ScalingPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type  = "ECSServiceAverageCPUUtilization"
    }
    target_value              = 90.0
  }
}