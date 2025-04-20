#######################################################################################
#                       RDS PostgreSql
#######################################################################################
data "aws_rds_engine_version" "postgres_latest" {
  engine = "postgres"
}

resource "aws_db_subnet_group" "postgres" {
  name = "postgres-subnet-group"
  subnet_ids = [ aws_subnet.private_1.id, aws_subnet.private_2.id ]

  tags = {
    Name = "PostgreSQL Subnet Group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "my-postgres-db"
  engine                 = "postgres"
  engine_version         = data.aws_rds_engine_version.postgres_latest.version 
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "mydb"
  username               = var.db_username
  password               = var.db_pass
  db_subnet_group_name   = aws_db_subnet_group.postgres.name 
  vpc_security_group_ids = [aws_security_group.main.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  backup_retention_period = 7

  tags = {
    Name = "Postgres Instance"
  }
}
