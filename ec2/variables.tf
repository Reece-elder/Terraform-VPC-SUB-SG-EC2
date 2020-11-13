variable "ami_uk" {
  description = "machine image uk"
  default     = "ami-0dc8d444ee2a42d8a"
}

variable "type" {
  default = "t2.micro"
}

variable "vpc_id_ec2"{
    default = "vpc_id_null"
}

variable "subnet_id_ec2"{
    default = "subnet_id_null"
}

variable "open_internet" {
  default = "0.0.0.0/0"
}
