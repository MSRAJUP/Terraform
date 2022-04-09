provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "us-east-1"
}
resource "aws_vpc" "main_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
  tags = {
    "Name" = "${var.vpc_name}"
  }
}
resource "aws_subnet" "public_subnet" {
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "${var.public_subnet}"
}
resource "aws_subnet" "private_subnet" {
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "${var.private_subnet}"
}
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main_vpc.id
}
resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    "Name" = "new_rt"
  }
}

resource "aws_route_table_association" "public_subnets" {
  route_table_id = aws_route_table.my_rt.id
  subnet_id = aws_subnet.public_subnet.id
}
resource "aws_route_table_association" "private_subnets" {
  route_table_id = aws_route_table.my_rt.id
  subnet_id = aws_subnet.private_subnet.id
}

resource "aws_security_group" "SG" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "allow_all"

  ingress {
    from_port = 0
    protocol  = "tcp"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "tcp"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terraform_server" {
  ami = "ami-0e472ba40eb589f49"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  key_name = "Test_key_pair"
  tags = {
    "Name" = "first_tf_server"
  }

  provisioner "file" {
    source = "nginx.sh"
    destination = "/temp/nginx.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo /tmp/nginx.sh"
    ]
  }

}
