resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# Public Subnet
resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-subnet"
  }
}

# Route Table
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-rt"
  }
}

# Internet route
resource "aws_route" "internet" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Associate subnet với route table
resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

# NACL
resource "aws_network_acl" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-nacl"
  }
}

# SSH inbound
resource "aws_network_acl_rule" "ssh_in" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# ICMP inbound
resource "aws_network_acl_rule" "icmp_in" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 110
  egress         = false
  protocol       = "icmp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = -1
  to_port        = -1
}

# Ephemeral ports
resource "aws_network_acl_rule" "ephemeral_in" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Outbound all
resource "aws_network_acl_rule" "all_out" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Associate NACL
resource "aws_network_acl_association" "this" {
  subnet_id      = aws_subnet.this.id
  network_acl_id = aws_network_acl.this.id
}