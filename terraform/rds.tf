resource "aws_db_subnet_group" "ror_db_subnet" {
  name       = "ror-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_instance" "ror_postgres" {
  identifier             = "ror-db"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "14.17"
  instance_class         = "db.t3.micro"
  username               = var.rds_username
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.ror_db_subnet.name
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
}
