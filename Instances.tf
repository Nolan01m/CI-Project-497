resource "aws_internet_gateway" "Gateway" {
  vpc_id = aws_vpc.aiexperts.id
}
resource "aws_route_table" "Routing" {
  vpc_id = aws_vpc.aiexperts.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Gateway.id
  }
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
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags = {
    Name = "allow_http(s)"
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
  depends_on                = [aws_internet_gateway.Gateway]
}