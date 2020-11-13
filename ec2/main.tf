resource "aws_security_group" "ssh_allowed" {
  vpc_id = var.vpc_id_ec2

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.open_internet]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.open_internet]
  }

  tags = {
    Name = "ssh_allowed"
  }
}

resource "aws_instance" "example" {
  ami                    = var.ami_uk
  instance_type          = var.type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ssh_allowed.id]
  subnet_id              = var.subnet_id_ec2
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYpHp/G0AwNz5Ga/a+vrA/6MhJ4Qcaju7501g1GbV/s4b2NPopl2BMKhXPMnh8d0dc0KighKCl966M097ziJ3vOe8SyJSBsVLXeIYh3HmlHm/Ec2Sn4xfoCsBBXh9Jrf305sLW6AUtjdpiYqON9+LjEecm6uEINou+wfbA9rU1iB9djSnI2FaOxtS3sDCLS/bPksUh/faSScjJIXF7JXNU7jtUIvqRdqVDcv5SqiQJPXUCyNzdpqsk+UnS4cfQTokR+XYtDMEXE439uT+EdFqQ5JrcXXeSIYxm8RSsf35oJBe85cluUaOtxwLMTNf23Zo3rHmu9jgLcok/xUBfUBn3 ubuntu@ip-172-31-46-112"
}