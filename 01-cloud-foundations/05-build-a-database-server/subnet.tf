# Create DB subnet group

data "aws_subnet" "lab_db_az_1" {
  vpc_id     = data.aws_vpc.lab_vpc.id
  cidr_block = "10.0.1.0/24"
}
data "aws_subnet" "lab_db_az_2" {
  vpc_id     = data.aws_vpc.lab_vpc.id
  cidr_block = "10.0.3.0/24"
}

resource "aws_db_subnet_group" "lab_db_subnet_group" {
  subnet_ids  = [data.aws_subnet.lab_db_az_1.id, data.aws_subnet.lab_db_az_2.id]
  name        = "db-subnet-group"
  description = "DB Subnet Group"

  tags = {
    Name = "DB-Subnet-Group"
  }
}
