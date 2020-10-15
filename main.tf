terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
#aiexperts.com
#test
# Create a VPC
resource "aws_vpc" "aiexperts" {
  cidr_block = "10.0.0.0/16"
}

# Create an EC2 instance
resource "aws_instance" "website" {
  ami           = "ami-0a5ce0c6788a56cf4"
  instance_type = "t2.micro"

  tags = {
    Name = "Website"
  }
}

# integrate lex
