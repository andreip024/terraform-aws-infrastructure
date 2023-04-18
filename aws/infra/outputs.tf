
output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "private_subnets" {
  value = aws_subnet.private_subnet.*.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}
output "sg" {
  value = aws_security_group.security_group.id
}

output "cloudwach_group" {
  value = aws_cloudwatch_log_group.cloudwach_logs_group.name
}