resource "aws_cloudwatch_log_group" "cloudwach_logs_group" {
  name              = "${local.project_name}-Logs-Group"
  retention_in_days = 90
}