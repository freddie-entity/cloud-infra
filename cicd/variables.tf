variable "aws_region" {
  default = "ap-southeast-1"
}

variable "env" {
  default = "dev"
}

variable "account_id" {
  default = "158904540988"
}

variable "artifacts_bucket_name" {
  default = "codepipeline-freddieentity"
}

variable "ecr_name" {
  default = "freddieentity"
}

variable "project_repository_branch" {
  default = "main"
}

variable "project_repository_name" {
  default = "fe-repo"
}

variable "aws_ecs_cluster_name" {
  default = "demo-fp-ecs-cluster"
}

variable "aws_ecs_python_app_service_name" {
  default = "demo-fp-ecs-svc-frontend"
}

variable "aws_ecs_container_name" {
  default = "fe_container"
}