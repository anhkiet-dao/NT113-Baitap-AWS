provider "aws" { region = var.region }

# 1. Gọi Networking Module
module "networking" {
  source      = "./modules/networking"
  for_each    = var.vpc_configs
  vpc_cidr    = each.value.cidr
  subnet_cidr = each.value.subnet
  az          = each.value.az
  vpc_name    = upper(each.key)
}

# 2. Gọi Transit Gateway Module
module "tgw" {
  source          = "./modules/transit_gateway"
  vpc_attachments = { for k, v in module.networking : k => { vpc_id = v.vpc_id, subnet_id = v.subnet_id } }
}

# 3. Cấu hình Route Table (Sau khi có TGW ID)
resource "aws_route_table" "main_rt" {
  for_each = var.vpc_configs
  vpc_id   = module.networking[each.key].vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.networking[each.key].igw_id
  }

  # Route traffic nội bộ qua Transit Gateway
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = module.tgw.tgw_id
  }

  tags = { Name = "RT-${upper(each.key)}" }
}

resource "aws_route_table_association" "a" {
  for_each       = var.vpc_configs
  subnet_id      = module.networking[each.key].subnet_id
  route_table_id = aws_route_table.main_rt[each.key].id
}

# 4. Gọi Compute Module
module "compute" {
  source        = "./modules/compute"
  for_each      = var.vpc_configs
  vpc_id        = module.networking[each.key].vpc_id
  subnet_id     = module.networking[each.key].subnet_id
  instance_name = "EC2-${upper(each.key)}"
  private_ip    = each.value.instance_ip
}