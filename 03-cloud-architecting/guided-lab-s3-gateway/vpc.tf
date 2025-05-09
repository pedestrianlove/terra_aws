data "aws_vpc" "on_prem_vpc" {
  filter {
    name   = "tag:Name"
    values = ["On-Prem-VPC"]
  }
}

data "aws_subnet" "on_prem_subnet" {
  vpc_id = data.aws_vpc.on_prem_vpc.id

  filter {
    name   = "tag:Name"
    values = ["On-Prem-Subnet"]
  }
}
