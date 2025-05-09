data "aws_ssm_parameter" "gateway_ami_param" {
  name = "/aws/service/storagegateway/ami/FILE_S3/latest"
}

data "aws_security_group" "lab_sg_file_gateway_access" {
  name = "*FileGatewayAccess*"
}

data "aws_security_group" "lab_sg_fgw_ssh" {
  name = "*OnPremSshAccess*"
}


resource "aws_instance" "gateway_instance" {
  ami           = data.aws_ssm_parameter.gateway_ami_param.value
  instance_type = "t2.xlarge"
  key_name      = "vockey"

  subnet_id = data.aws_subnet.on_prem_subnet.id

  vpc_security_group_ids = [
    data.aws_security_group.lab_sg_file_gateway_access.id,
    data.aws_security_group.lab_sg_fgw_ssh.id
  ]

  associate_public_ip_address = true

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = 150
    delete_on_termination = true
  }

  tags = {
    Name = "File Gateway Appliance"
  }
}

resource "aws_storagegateway_gateway" "lab_s3_gateway" {
  gateway_name       = "File Gateway"
  gateway_timezone   = "GMT-5:00"
  gateway_type       = "FILE_S3"
  gateway_ip_address = aws_instance.gateway_instance.public_ip
}

data "aws_storagegateway_local_disk" "lab_gateway_disk" {
  disk_node   = "/dev/sdb"
  gateway_arn = aws_storagegateway_gateway.lab_s3_gateway.arn
}

resource "aws_storagegateway_cache" "lab_s3_gateway_cache" {
  gateway_arn = aws_storagegateway_gateway.lab_s3_gateway.arn
  disk_id     = data.aws_storagegateway_local_disk.lab_gateway_disk.id
}

resource "aws_storagegateway_nfs_file_share" "example" {
  client_list           = ["0.0.0.0/0"]
  gateway_arn           = aws_storagegateway_gateway.lab_s3_gateway.arn
  location_arn          = aws_s3_bucket.lab_bucket_east_2.arn
  role_arn              = "arn:aws:iam::483758138273:role/c149771a3854269l10247883t1w483758138273-FgwRole-BZawcU3TXryR"
  default_storage_class = "S3_STANDARD"
}
