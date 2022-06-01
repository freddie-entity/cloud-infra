[
  {
    "name": "${container_name}",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${cloudwatch_logs_ecs_directory}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "environment": [
      {"name": "MONGODB_URI", "value": "mongodb+srv://root:Password123@mobileshop.bgzda.mongodb.net/mobileShop?retryWrites=true&w=majority"}
    ],
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${container_port}
      }
    ]
  }
]