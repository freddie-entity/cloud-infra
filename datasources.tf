data "aws_availability_zones" "aaz" {
}

data "template_file" "frontend_td_tpl" {
  template = file("./frontend-td.json.tpl")

  vars = {
    app_image                     = var.app_image_frontend
    container_port                = var.container_port_frontend
    fargate_cpu                   = var.fargate_cpu
    fargate_memory                = var.fargate_memory
    aws_region                    = var.region
    container_name                = var.container_name_frontend
    cloudwatch_logs_ecs_directory = aws_cloudwatch_log_group.frontend_log_group.name
    # api_url = "${aws_service_discovery_service.backend.name}.${aws_service_discovery_private_dns_namespace.microservices.name}:5000/api"
    api_url                       = "${aws_alb.alb_be.dns_name}"
  }
}

data "template_file" "backend_td_tpl" {
  template = file("./backend-td.json.tpl")

  vars = {
    app_image                     = var.app_image_backend
    container_port                = var.container_port_backend
    fargate_cpu                   = var.fargate_cpu
    fargate_memory                = var.fargate_memory
    aws_region                    = var.region
    container_name                = var.container_name_backend
    cloudwatch_logs_ecs_directory = aws_cloudwatch_log_group.backend_log_group.name
  }
}