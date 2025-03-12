# Launch Web Server
data "aws_instance" "lab_web_server" {
  instance_tags = {
    Name = "Lab"
  }
}

resource "aws_ebs_volume" "lab_new_volume" {
  availability_zone = "us-east-1a"
  size              = 1
  type              = "gp2"

  tags = {
    Name = "My Volume"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.lab_new_volume.id
  instance_id = data.aws_instance.lab_web_server.id
}

# Create snapshot from EBS volume (uncomment after making changes to the mounted volume)
# resource "aws_ebs_snapshot" "lab_ebs_snapshot" {
#   volume_id = aws_ebs_volume.lab_new_volume.id
#
#   tags = {
#     Name = "My Snapshot"
#   }
# }
# resource "aws_ebs_volume" "lab_ebs_restored_volume" {
#   availability_zone = "us-east-1a"
#   snapshot_id       = aws_ebs_snapshot.lab_ebs_snapshot.id
#
#   tags = {
#     Name = "Restored Volume"
#   }
# }
# resource "aws_volume_attachment" "ebs_att_backup" {
#   device_name = "/dev/sdg"
#   volume_id   = aws_ebs_volume.lab_ebs_restored_volume.id
#   instance_id = data.aws_instance.lab_web_server.id
# }
