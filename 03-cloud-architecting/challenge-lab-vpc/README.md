# 重現bug的指示

## 1. 安裝terraform/awscli
```bash
sudo apt install -y terraform awscli # 或使用brew/pacman安裝
```

## 2. 打開Lab，並點開右上角的AWS Details複制awscli的憑證，並貼進`~/.aws/credentials`中
```bash
mkdir ~/.aws
vim ~/.aws/credentials # 或用nano, vscode打開，貼進去，存檔離開
```

## 3. 在目錄下初始化terraform，並apply現有的設定至AWS Academy的Sandbox中。
```bash
terraform init
terraform apply
```

## 4. 會出現一些錯誤，這是因為AWS Academy的Sandbox中沒有給Revoke Security Group Egress的權限，所以我們需要untaint這些狀態:(雲端已經建立security group了，但terraform會覺得不乾淨，所以每次都會重建，但又會出錯)
```bash
terraform untaint aws_security_group.lab_sg_bastion
terraform untaint aws_security_group.lab_sg_private
terraform untaint aws_security_group.lab_sg_test
```

## 5. 再次apply
```bash
terraform apply
```

## 6. 現在進入AWS Console即可看到已經建立的Network ACL，但腳本卻沒有抓到。
