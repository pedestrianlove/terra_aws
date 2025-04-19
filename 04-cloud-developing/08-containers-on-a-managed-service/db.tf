resource "aws_db_subnet_group" "lab_aurora_subnet_group" {
  name = "lab-aurora-subnet-group"
  subnet_ids = [
    data.aws_subnet.lab_public_subnet_1.id,
    aws_subnet.lab_public_subnet_2.id,
  ]
}

resource "aws_rds_cluster" "lab_aurora_cluster" {
  cluster_identifier = "supplierdb"
  engine             = "aurora-mysql"
  engine_mode        = "provisioned"
  engine_version     = "8.0.mysql_aurora.3.07.0"
  master_username    = "admin"
  master_password    = "coffee_beans_for_all"
  database_name      = "suppliers"

  performance_insights_enabled = false
  enable_http_endpoint         = true

  vpc_security_group_ids = [data.aws_security_group.lab_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.lab_aurora_subnet_group.name

  serverlessv2_scaling_configuration {
    max_capacity = 16
    min_capacity = 2
  }
}

resource "aws_rds_cluster_instance" "lab_aurora_instance" {
  cluster_identifier = aws_rds_cluster.lab_aurora_cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.lab_aurora_cluster.engine
  engine_version     = aws_rds_cluster.lab_aurora_cluster.engine_version

  db_subnet_group_name = aws_db_subnet_group.lab_aurora_subnet_group.name
}
