#/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install python3 python3-pip python-is-python3 git curl wget -y
python3 -m pip install --upgrade pip
sudo apt install awscli -y
sudo aws configure
git clone https://github.com/skysoftbg/devops-project.git
cd devops-project/
./tf-ubuntu.sh 
terraform version
ssh-keygen
cp /home/ruslan/.ssh/id_rsa /home/ruslan/.ssh/id_rsa.pub .
terraform init
terraform fmt
terraform validate
sudo terraform plan
sudo terraform apply
ssh ec2-user@54.165.194.204
