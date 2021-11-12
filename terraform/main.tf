# random string for flask secret-key env variable
resource "random_string" "flask-secret-key" {
  length = 16
  special = true
  override_special = "/@\" "
}

# create the ECS cluster
resource "aws_ecs_cluster" "fa-ecs-cluster" {
  name = "flask-app"

  tags = {
    Name = "flask-app"
  }
}

# create and define the container task
resource "aws_ecs_task_definition" "fa-ecs-task" {
  family = "flask-app"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 512
  memory = 2048
  container_definitions = <<DEFINITION
[
   {
      "name":"flask-app",
      "image":"${var.flask_app_image}",
      "essential":true,
      "portMappings":[
         {
            "containerPort":8080,
            "hostPort":8080,
            "protocol":"tcp"
         }
      ],
      "environment":[
         {
            "name":"FLASK_APP",
            "value":"${var.flask_app}"
         },
         {
            "name":"FLASK_ENV",
            "value":"${var.flask_env}"
         },
         {
            "name":"APP_HOME",
            "value":"${var.app_home}"
         },
         {
            "name":"APP_PORT",
            "value":"${var.flask_app_port}"
         },
         {
            "name":"APP_SECRET_KEY",
            "value":"${random_string.flask-secret-key.result}"
         }
      ]
   }
]
DEFINITION
}

resource "aws_ecs_service" "flask-service" {
  name = "flask-app-service"
  cluster = aws_ecs_cluster.fa-ecs-cluster.id
  task_definition = aws_ecs_task_definition.fa-ecs-task.arn
  desired_count = 2
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.fa-ecs-sg.id]
    subnets = aws_subnet.fa-public-subnets.*.id
    assign_public_ip = true
  }

  load_balancer {
    container_name = "flask-app"
    container_port = var.flask_app_port
    target_group_arn = aws_alb_target_group.fa-target-group.id
  }

  depends_on = [
    aws_alb_listener.fa-alb-listener
  ]
}