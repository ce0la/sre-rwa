provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_key_pair" "ubuntu" {
  key_name   = "ubuntu"
  public_key = file("corwa.pub")
}

resource "aws_security_group" "ubuntu" {
  name        = "ubuntu-security-group"
  description = "Allow HTTP, HTTPS and SSH traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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

  tags = {
    Name = "terraform"
  }
}


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

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  key_name      = aws_key_pair.ubuntu.key_name
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo apt -y install apache2
                  wget https://raw.githubusercontent.com/ce0la/sre-rwa/master/task1/index.html
                  cp index.html /var/www/html/index.html
                  EOF

  tags = {
    Name = "ubuntu"
  }

  vpc_security_group_ids = [
    aws_security_group.ubuntu.id
  ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("corwa")
    host        = self.public_ip
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 30
  }
}

resource "aws_eip" "ubuntu" {
  vpc      = true
  instance = aws_instance.ubuntu.id
}

output "DNS" {
  value = aws_instance.ubuntu.public_dns
}
