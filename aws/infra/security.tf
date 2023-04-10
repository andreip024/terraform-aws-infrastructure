resource "aws_security_group" "security_group" {
    name        = "${local.project_name}-SecurityGroup-ECS-ALB"
    description = "Security Group for ALB to ECS cluster"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port   = 0
        protocol    = -1
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        protocol    = -1
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}