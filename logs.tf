# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "frontend_log_group" {
  name              = "/ecs/ecs-cwl-demo/frontend"
  retention_in_days = 30

  tags = {
    Name = "/ecs/ecs-cwl-demo/frontend"
  }
}

resource "aws_cloudwatch_log_stream" "frontend_log_stream" {
  name           = "my-log-stream"
  log_group_name = aws_cloudwatch_log_group.frontend_log_group.name
}

resource "aws_cloudwatch_log_group" "backend_log_group" {
  name              = "/ecs/ecs-cwl-demo/backend"
  retention_in_days = 30

  tags = {
    Name = "/ecs/ecs-cwl-demo/backend"
  }
}

resource "aws_cloudwatch_log_stream" "backend_log_stream" {
  name           = "my-log-stream"
  log_group_name = aws_cloudwatch_log_group.backend_log_group.name
}