resource "aws_instance" "my_ec2" {
  ami = "ami-0440d3b780d96b29d"
  instance_type = "t3.micro"
  security_groups = [aws_security_group.my_sg.name]
  key_name = "MyKey"
  tags = {
    Name = "MyEC2Instance"
  }
}

resource "aws_security_group" "my_sg" {
  name        = "MySg"
  description = "security group for MyEC2Instance"
  vpc_id      = "vpc-0cb7a9dcc1ff1cbd1"

  tags = {
    Name = "MySg"
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_key_pair" "my_key" {
  key_name   = "MyKey"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "pr_key" {
  content = tls_private_key.rsa.private_key_pem
  filename = "PrKey"
}