provider "aws" {
  region = "ap-southeast-1"
}

# =========================
# VPC A
# =========================
module "vpc_a" {
  source = "./modules/vpc"

  name        = var.vpc_a_name
  vpc_cidr    = var.vpc_a_cidr
  subnet_cidr = var.vpc_a_subnet_cidr
}

# =========================
# VPC B
# =========================
module "vpc_b" {
  source = "./modules/vpc"

  name        = var.vpc_b_name
  vpc_cidr    = var.vpc_b_cidr
  subnet_cidr = var.vpc_b_subnet_cidr
}

# =========================
# EC2 A
# =========================
module "ec2_a" {
  source = "./modules/ec2"

  name         = "EC2-A"
  vpc_id       = module.vpc_a.vpc_id
  subnet_id    = module.vpc_a.subnet_id
  allowed_cidr = var.vpc_b_cidr
  key_name     = var.key_name
}

# =========================
# EC2 B
# =========================
module "ec2_b" {
  source = "./modules/ec2"

  name         = "EC2-B"
  vpc_id       = module.vpc_b.vpc_id
  subnet_id    = module.vpc_b.subnet_id
  allowed_cidr = var.vpc_a_cidr
  key_name     = var.key_name
}

# =========================
# VPC PEERING
# =========================
module "peering" {
  source = "./modules/peering"

  vpc_a_id      = module.vpc_a.vpc_id
  vpc_b_id      = module.vpc_b.vpc_id
  vpc_a_cidr    = var.vpc_a_cidr
  vpc_b_cidr    = var.vpc_b_cidr
  route_table_a = module.vpc_a.route_table_id
  route_table_b = module.vpc_b.route_table_id
}