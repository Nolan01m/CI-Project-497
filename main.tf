//# Hostname = aiexperts.com

terraform {
backend "remote" {}
    //# allow emote execute tf code from local cli

//# Specifying Cloud Provider
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
//# Create a VPC
resource "aws_vpc" "aiexperts" {
  cidr_block = "10.0.0.0/16"  
  tags = {
    Name = "AIExperts"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.aiexperts.id
}
//# Creating a Security Group
resource "aws_security_group" "default" {
  name        = "allow_https"
  description = "Allow https inbound traffic"
  vpc_id = aws_vpc.aiexperts.id

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 443
    to_port   = 443
    cidr_blocks = [aws_vpc.aiexperts.cidr_block]
  }
  tags = {
    Name = "allow_https"
  }
}
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.aiexperts.id
  cidr_block        = "10.0.0.0/16"
  availability_zone = "us-east-1a"

  tags = {
    Name = "aiexperts_subnet"
  }
}
resource "aws_network_interface" "Int" {
  subnet_id   = aws_subnet.subnet.id
  private_ips = ["10.0.100.0"]
  security_groups = [aws_security_group.default.id]

  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_eip" "External_IP" {
  instance = aws_instance.website.id
  vpc      = true
  associate_with_private_ip = "10.0.100.0"
  depends_on                = [aws_internet_gateway.gw]
}
//# Create an EC2 instance
resource "aws_instance" "website" {

  ami           = "ami-0a5ce0c6788a56cf4"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.Int.id
    device_index         = 0
    
  }

  tags = {
    Name = "Website"
  }
}

//# Integrate lex 