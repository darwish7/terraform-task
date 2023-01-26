data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"

        values = ["hvm"]
    }
    filter {

        name   = "architecture"

        values = ["x86_64"]
    }
    owners = ["099720109477"] 
}


resource "aws_security_group" "private-sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}


resource "aws_instance" "private_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  count = length(var.subnet_ids)
  subnet_id     = var.subnet_ids[count.index]
  vpc_security_group_ids = [ aws_security_group.private-sg.id ]
  user_data = <<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install apache2 -y
        sudo apt install curl -y
        sudo systemctl start apache2
        sudo systemctl enable apache2 
        sudo rm /var/www/html/index.html
        sudo touch /var/www/html/index.html
        sudo chmod 777 /var/www/html/index.html
        hostname -I | awk '{print $1}' >> /var/www/html/index.html
  EOF

  tags = {
    Name = var.private_ec2_name
  }
}