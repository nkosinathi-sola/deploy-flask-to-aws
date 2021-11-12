# create a security group to access the ECS application
resource "aws_security_group" "fa-alb-sg" {
  name = "fa-app-alb"
  description = "control access to the application load balancer"
  vpc_id = aws_vpc.fa-vpc.id

  ingress {
    from_port = 80
    protocol = "TCP"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create security group to access the ecs cluster (traffic to ecs cluster should only come from the ALB)
resource "aws_security_group" "fa-ecs-sg" {
  name = "fa-app-ecs-from-alb"
  description = "control access to the ecs cluster"
  vpc_id = aws_vpc.fa-vpc.id

  ingress {
    from_port = var.flask_app_port
    protocol = "TCP"
    to_port = var.flask_app_port
    security_groups = [aws_security_group.fa-alb-sg.id]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create the ALB
resource "aws_alb" "fa-alb" {
  load_balancer_type = "application"
  name = "fa-alb"
  subnets = aws_subnet.fa-public-subnets.*.id
  security_groups = [aws_security_group.fa-alb-sg.id]
}

# point redirected traffic to the app
resource "aws_alb_target_group" "fa-target-group" {
  name = "fa-ecs-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.fa-vpc.id
  target_type = "ip"
}

# direct traffic through the ALB
resource "aws_alb_listener" "fa-alb-listener" {
  load_balancer_arn = aws_alb.fa-alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.fa-target-group.arn
    type = "forward"
  }
}