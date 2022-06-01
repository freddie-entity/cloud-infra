output "alb_hostname_fe" {
  value = aws_alb.alb_fe.dns_name
}

output "alb_hostname_be" {
  value = aws_alb.alb_be.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs.name
}

output "ecs_svc_fe" {
  value = aws_ecs_service.ecs_svc_fe.name
}

output "ecs_svc_be" {
  value = aws_ecs_service.ecs_svc_be.name
}