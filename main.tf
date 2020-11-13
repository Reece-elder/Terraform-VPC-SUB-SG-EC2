provider "aws" {
  region = var.AWS_REGION
}

module "vpc-igw-1" {
  source = "./vpc"
}

module "ec2_1" {
  source        = "./ec2"
  vpc_id_ec2    = module.vpc-igw-1.vpc_id
  subnet_id_ec2 = module.vpc-igw-1.subnet_id
}

