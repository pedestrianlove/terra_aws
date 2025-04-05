# 如何快速重現bug

## 1. 安裝terraform/awscli
- Terraform: https://developer.hashicorp.com/terraform/install
- AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
```bash
brew install terraform awscli # 其它平台可想辦法安裝awscli跟terraform
```

## 2. 開始Lab，並點開右上角的AWS Details複制awscli的憑證，並貼進`~/.aws/credentials`中
```bash
mkdir ~/.aws
vim ~/.aws/credentials # 或用nano, vscode打開，貼進去，存檔離開
```

## 3. 在目錄下初始化terraform，並apply現有的設定至AWS Academy的Sandbox中。
```bash
terraform init
terraform apply
```

## 4. 會出現一些錯誤，這是因為AWS Academy的Sandbox中沒有給Revoke Security Group Egress的權限，所以我們需要untaint已經apply上去的這些狀態:(雲端已經建立security group了，但terraform會覺得不乾淨，所以每次都會重建，進入無限循環)
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
