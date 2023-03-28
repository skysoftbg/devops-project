locals {
  azs = data.aws_availability_zones.available.names
}

data "aws_availability_zones" "available" {}

resource "aws_key_pair" "jenkins_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "jenkins" {
  count                  = var.instance_count
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.public_subnet[count.index].id
  key_name               = aws_key_pair.jenkins_auth.id

  tags = {
    Name = "jenkins-instance-${count.index + 1}"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./id_rsa")
    host        = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yun install python3-pip -y",
      "python3 -m pip install --user ansible",
      "sudo amazon-linux-extras install java-openjdk11 -y",
      "sudo yum update -y",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum install epel-release -y" ,
      "sudo yum install java-11-openjdk-devel -y",
      "sudo yum install jenkins -y",
      "sudo systemctl start jenkins",
      "echo 'Initial Jenkins Password id:'",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
    ]
  }
  depends_on = [aws_key_pair.jenkins_auth]

}
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "jenkins-vpc"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "jenkins_igw"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]


  tags = {
    Name = "jenkins-public-${count.index + 1}"
  }
}

resource "aws_security_group" "sg" {
  name        = "public_sg"
  description = "Security group for public instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "jenkins-public"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(local.azs)
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}


output "jenkins_access" {
  value = { for i in aws_instance.jenkins[*] : i.tags.Name => "${i.public_ip}" }
}

output "instance_ips" {
  value = [for i in aws_instance.jenkins[*] : i.public_ip]
}

output "instance_ids" {
  value = [for i in aws_instance.jenkins[*] : i.id]
}
