provider "aws" {
  region = "${var.AWS_REGION}"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "public"
  }
}

resource "aws_internet_gateway" "prod_igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "prod_igw"
  }
}

resource "aws_route_table" "prod_public_crt" {

  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_igw.id
  }

  tags = {
    Name = "prod_public_crt"
  }
}

resource "aws_route_table_association" "prod_crta_public_subnet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.prod_public_crt.id
}

resource "aws_security_group" "ssh_allowed" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh_allowed"
  }
}

resource "aws_instance" "example" {
  ami                    = var.ami-uk
  instance_type          = var.type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ssh_allowed.id]
  subnet_id              = aws_subnet.public.id
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYpHp/G0AwNz5Ga/a+vrA/6MhJ4Qcaju7501g1GbV/s4b2NPopl2BMKhXPMnh8d0dc0KighKCl966M097ziJ3vOe8SyJSBsVLXeIYh3HmlHm/Ec2Sn4xfoCsBBXh9Jrf305sLW6AUtjdpiYqON9+LjEecm6uEINou+wfbA9rU1iB9djSnI2FaOxtS3sDCLS/bPksUh/faSScjJIXF7JXNU7jtUIvqRdqVDcv5SqiQJPXUCyNzdpqsk+UnS4cfQTokR+XYtDMEXE439uT+EdFqQ5JrcXXeSIYxm8RSsf35oJBe85cluUaOtxwLMTNf23Zo3rHmu9jgLcok/xUBfUBn3 ubuntu@ip-172-31-46-112"
}