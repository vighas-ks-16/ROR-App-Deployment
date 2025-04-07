resource "aws_ecs_cluster" "ror_cluster" {
  name = "ror-ecs-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "ror_task" {
  family                   = "ror-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "ror-app"
    image = "891377398861.dkr.ecr.us-east-1.amazonaws.com/ror-app:latest"
    portMappings = [{
      containerPort = 3000
    }]
    environment = [
      { name = "RDS_DB_NAME", value = var.rds_db_name },
      { name = "RDS_USERNAME", value = var.rds_username },
      { name = "RDS_PASSWORD", value = var.rds_password },
      { name = "S3_BUCKET_NAME", value = aws_s3_bucket.ror_s3.bucket }
    ]
  }])
}

resource "aws_ecs_service" "ror_service" {
  name            = "ror-service"
  cluster         = aws_ecs_cluster.ror_cluster.id
  task_definition = aws_ecs_task_definition.ror_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [for subnet in aws_subnet.public : subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ror_tg.arn
    container_name   = "ror-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.http]
}
