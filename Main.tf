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