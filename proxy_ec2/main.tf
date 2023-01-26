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


resource "aws_security_group" "proxy-sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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


resource "aws_instance" "proxy_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  count = length(var.subnet_ids)
  subnet_id     = var.subnet_ids[count.index]
  associate_public_ip_address = "true"
  vpc_security_group_ids = [ aws_security_group.proxy-sg.id ]
  key_name = "terraform"
  provisioner "local-exec" {
    when = create
    command = "echo public-ip${count.index+1}  ${self.public_ip} >> ./all-ips.txt"
  }
  provisioner "remote-exec" {
     inline = var.inline-provisioner-remote-exec
  }
  connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = file("~/terraform.pem")
      timeout = "5m"
    }

  tags = {
    Name = var.public_ec2_name
  }
}