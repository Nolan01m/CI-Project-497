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
//##Instances##\\
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