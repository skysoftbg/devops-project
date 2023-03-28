PG DO DevOps Project 1

Automating Infrastructure using Terraform
Course-end Project 1
DESCRIPTION
Use Terraform to provision infrastructure
 
Description:
Nowadays, infrastructure automation is critical. We tend to put the most emphasis on software development processes, but infrastructure deployment strategy is just as important. Infrastructure automation not only aids disaster recovery, but it also facilitates testing and development.
 
Your organization is adopting the DevOps methodology and in order to automate provisioning of infrastructure there's a need to setup a centralised server for Jenkins.
Terraform is a tool that allows you to provision various infrastructure components. Ansible is a platform for managing configurations and deploying applications. It means you'll use Terraform to build a virtual machine, for example, and then use Ansible to instal the necessary applications on that machine.
Considering the Organizational requirement you are asked to automate the infrastructure using Terraform first and install other required automation tools in it.
Tools required: Terraform, AWS account with security credentials, Keypair
 
Expected Deliverables:
•	Launch an EC2 instance using Terraform
•	Connect to the instance
•	Install Jenkins, Java and Python in the instance

Steps:

1. Install AWS ClI
2. Create AWS Secutiy Credentials
3. Configure AWS CLI 
4. Install Terraform
5. Create Keypair
6. Copy public and private key's.
7. Use terraform to deploy and lanh instance in AWS.
8. Entire process is packed in setup.sh just execute it to deploy!!!
