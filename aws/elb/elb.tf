resource "aws_lb" "app_lb" {
    name                        = "${local.project_name}-LB"
    internal                    = false
    load_balancer_type          = "application"
    security_groups             = [ data.terraform_remote_state.infra.outputs.sg ]
    subnets                     = data.terraform_remote_state.infra.outputs.public_subnets

}

resource "aws_alb_target_group" "app_lb_target_group" {
  name        = "${local.project_name}-TargetGroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id
  target_type = "ip"
 
  health_check {
   healthy_threshold   = "3"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "5"
   path                = "/"
   unhealthy_threshold = "2"
  }
}

# resource "aws_alb_listener" "alb_lisener" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = 80
#   protocol          = "HTTP"
 
#   default_action {
#     target_group_arn = aws_alb_target_group.app_lb_target_group.arn
#     type             = "forward"
#   }
# }