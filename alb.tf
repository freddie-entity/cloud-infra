resource "aws_alb" "alb_fe" {
  name            = "${var.app_name}-alb-fe"
  internal        = false
  subnets         = aws_subnet.subnet_public.*.id
  security_groups = [aws_security_group.sg_alb.id]
}

resource "aws_alb_target_group" "alb_tg_fe" {
  name        = "${var.app_name}-alb-tg-${random_string.alb_prefix.result}"
  port        = var.container_port_frontend
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true # prevent from deleting target group without replacement while it's being listen by listener
  }

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "alb_listener_fe" {
  load_balancer_arn = aws_alb.alb_fe.id
  port              = 80 # from alb
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_tg_fe.id
    type             = "forward"
  }

  tags = {
    Name = "alb-listener-to-container-fe"
  }

  depends_on = [aws_alb_target_group.alb_tg_fe]
}

resource "aws_alb_listener" "alb_https_listener" {
  load_balancer_arn = aws_alb.alb_fe.id
  port              = 443 # from alb
  protocol          = "HTTPS"
  ssl_policy  = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = aws_acm_certificate.ecs_domain_certificate.arn

  default_action {
    target_group_arn = aws_alb_target_group.alb_tg_fe.id
    type             = "forward"
  }

  tags = {
    Name = "alb-listener-to-container-${var.app_image_frontend}"
  }

  depends_on = [aws_alb_target_group.alb_tg_fe]
}



resource "aws_alb" "alb_be" {
  name            = "${var.app_name}-alb-be"
  internal        = false
  subnets         = aws_subnet.subnet_public.*.id
  security_groups = [aws_security_group.sg_alb.id]
}

resource "aws_alb_target_group" "alb_tg_be" {
  name        = "${var.app_name}-alb-tg-be-${random_string.alb_prefix.result}"
  port        = var.container_port_backend
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true # prevent from deleting target group without replacement while it's being listen by listener
  }

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "alb_listener_be" {
  load_balancer_arn = aws_alb.alb_be.id
  port              = 80 # from alb
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_tg_be.id
    type             = "forward"
  }

  tags = {
    Name = "alb-listener-to-container-be"
  }

  depends_on = [aws_alb_target_group.alb_tg_be]
}