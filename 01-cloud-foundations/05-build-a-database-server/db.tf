# Create RDS instance under the subnet group
resource "aws_db_instance" "lab_rds_instance" {
  identifier = "lab-db"

  # MySQL settings
  multi_az          = true
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"

  # Credentials
  db_name  = "lab"
  username = "main"
  password = "lab-password"

  # Connectivity
  db_subnet_group_name = "db-subnet-group"
  vpc_security_group_ids = [
    aws_security_group.lab_rds_security_group.id
  ]

  depends_on = [aws_db_subnet_group.lab_db_subnet_group]
}

