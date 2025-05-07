data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "Lab VPC"
  }
}
data "aws_vpc" "shared_vpc" {
  tags = {
    Name = "Shared VPC"
  }
}


resource "aws_vpc_peering_connection" "lab_vpc_peering" {
  peer_vpc_id = data.aws_vpc.shared_vpc.id
  vpc_id      = data.aws_vpc.lab_vpc.id
  auto_accept = true

  tags = {
    Name = "Lab-Peer"
  }
}
