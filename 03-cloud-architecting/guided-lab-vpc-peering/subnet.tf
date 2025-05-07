data "aws_route_table" "lab_public_rtb" {
  tags = {
    Name = "Lab Public Route Table"
  }
}
resource "aws_route" "lab_vpc_peering_route" {
  route_table_id            = data.aws_route_table.lab_public_rtb.id
  destination_cidr_block    = "10.5.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.lab_vpc_peering.id
}

data "aws_route_table" "lab_shared_public_rtb" {
  tags = {
    Name = "Shared-VPC Route Table"
  }
}
resource "aws_route" "lab_shared_vpc_peering_route" {
  route_table_id            = data.aws_route_table.lab_shared_public_rtb.id
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.lab_vpc_peering.id
}
