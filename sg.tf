resource "aws_security_group" "sg_alb" {
  name        = "${var.app_name}-sg-alb"
  description = "SG for ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol    = "TCP"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "TCP"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_ecs_tasks" {
  name        = "${var.app_name}-sg-ecs-tasks"
  description = "SG for ECS Tasks"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol        = "TCP"
    from_port       = var.container_port_frontend
    to_port         = var.container_port_frontend
    security_groups = [aws_security_group.sg_alb.id]
  }

  ingress {
    protocol  = "TCP"
    from_port = var.container_port_backend
    to_port   = var.container_port_backend
    # security_groups = [aws_security_group.sg_alb.id]
    # cidr_blocks      = [aws_vpc.vpc.cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}