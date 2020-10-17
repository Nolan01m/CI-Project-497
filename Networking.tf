resource "aws_internet_gateway" "Gateway" {
  vpc_id = aws_vpc.aiexperts.id
}
resource "aws_egress_only_internet_gateway" "Egress" {
  vpc_id = aws_vpc.aiexperts.id
}
resource "aws_route_table" "Routing" {
  vpc_id = aws_vpc.aiexperts.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Gateway.id
        }
  route {
    ipv6_cidr_block = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.Egress.id
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
  private_ips = ["10.0.0.50"]
  security_groups = [aws_security_group.default.id]
}
#added Website
resource "aws_eip" "External_IP" {
  instance = aws_instance.Website.id
  vpc      = true
  associate_with_private_ip = "10.0.0.2"
  depends_on                = [aws_internet_gateway.Gateway]
}
//# Creating a Security Group
resource "aws_security_group" "default" {
  name        = "allow_http(s)"
  description = "Allow http(s) inbound traffic"
  vpc_id = aws_vpc.aiexperts.id

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
    self = true
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] 
    self = true
  }
  tags = {
    Name = "allow_http(s)"
  }
}
