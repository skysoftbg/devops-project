terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
sleep 10

docker exec `docker ps | grep jenkins | awk '{ print $1}' ` cat /var/jenkins_home/secrets/initialAdminPassword
