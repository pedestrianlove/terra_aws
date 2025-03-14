data "aws_instance" "lab_instance" {
  instance_tags = {
    Name = "LabInstance"
  }
}

data "aws_ebs_volume" "lab_instance_ebs_volume" {
  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.lab_instance.id]
  }
}

resource "aws_ebs_snapshot" "lab_instance_ebs_snapshot" {
  volume_id = data.aws_ebs_volume.lab_instance_ebs_volume.id

  tags = {
    Name = "Unencrypted Root Volume"
  }
}
resource "aws_ebs_volume" "lab_instance_ebs_encrypted_volume" {
  snapshot_id       = aws_ebs_snapshot.lab_instance_ebs_snapshot.id
  availability_zone = data.aws_instance.lab_instance.availability_zone
  kms_key_id        = aws_kms_key.lab_kms_key.arn
  encrypted         = true
}

# 這個跑完後，需要再:
# 1. 手動detach跟attach
# 2. 重新命名volume
# 3. disable kms key
# 4. try to start instance
# 5. enable kms key
# 6. start instance
