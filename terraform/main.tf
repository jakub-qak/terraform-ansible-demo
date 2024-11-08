provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "web_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "web_subnet" {
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.web_vpc.id

  # Ingress rule for HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule for SSH (port 22)
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

resource "aws_instance" "web_server" {
  ami                         = "ami-042e8287309f5df03"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.web_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name                    = "web_server"

  tags = {
    Name = "WebServer"
  }
}


output "instance_ip" {
  value = aws_instance.web_server.public_ip
}
