resource "aws_ecs_cluster" "ecs" {
  name = "${var.app_name}-ecs-cluster"
}

####Frontend

resource "aws_ecs_task_definition" "ecs_td_fe" {
  family                   = "${var.app_name}-ecs-td-fe"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.frontend_td_tpl.rendered
}

resource "aws_ecs_service" "ecs_svc_fe" {
  name            = "${var.app_name}-ecs-svc-frontend"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.ecs_td_fe.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.sg_ecs_tasks.id]
    subnets          = aws_subnet.subnet_public.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_tg_fe.id
    container_name   = var.container_name_frontend
    container_port   = var.container_port_frontend
  }

  depends_on = [aws_iam_role.ecs_task_execution_role, aws_alb_listener.alb_listener_fe, aws_ecs_task_definition.ecs_td_fe]
}

####Backend

resource "aws_ecs_task_definition" "ecs_td_be" {
  family                   = "${var.app_name}-ecs-td-be"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.backend_td_tpl.rendered
}

resource "aws_ecs_service" "ecs_svc_be" {
  name            = "${var.app_name}-ecs-svc-backend"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.ecs_td_be.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.sg_ecs_tasks.id]
    subnets          = aws_subnet.subnet_public.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_tg_be.id
    container_name   = var.container_name_backend
    container_port   = var.container_port_backend
  }

  # service_registries {
  #   registry_arn = aws_service_discovery_service.backend.arn
  # }

  depends_on = [aws_iam_role.ecs_task_execution_role, aws_alb_listener.alb_listener_be, aws_ecs_task_definition.ecs_td_be]
}