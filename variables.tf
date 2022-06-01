variable "region" {
  default = "ap-southeast-1"
}

variable "app_name" {
  default = "demo-fp"
}

variable "app_domain" {
  default = "freddieentity.link"
}

variable "az_span" {
  default = 2
}
variable "container_port_frontend" {
  default = 80
}

variable "container_port_backend" {
  default = 5000
}

variable "container_name_frontend" {
  default = "fe_container"
}

variable "container_name_backend" {
  default = "be_container"
}

variable "health_check_path" {
  default = "/"
}

variable "app_image_frontend" {
  description = "Docker image to run in the ECS cluster"
  default     = "0908887875/cart-fe:v1"
  # default = "158904540988.dkr.ecr.ap-southeast-1.amazonaws.com/freddieentity"
}

variable "app_image_backend" {
  description = "Docker image to run in the ECS cluster"
  default     = "duypk2000/backend:latest"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "512"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "1024"
}


variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "cloudwatch_logs_ecs_directory" {
  description = "Cloudwatch logs for ecs to track containers"
  default     = "/ecs/ecs-cwl-demo/frontend"
}

variable "cloudwatch_logs_ecs_directory_backend" {
  description = "Cloudwatch logs for ecs to track containers"
  default     = "/ecs/ecs-cwl-demo/backend"
}