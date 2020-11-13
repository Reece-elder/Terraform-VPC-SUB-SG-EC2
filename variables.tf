variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "ami-uk" {
  description = "machine image uk"
  default     = "ami-0dc8d444ee2a42d8a"
}

variable "type" {
  default = "t2.micro"
}