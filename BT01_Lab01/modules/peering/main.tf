resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.vpc_a_id
  peer_vpc_id = var.vpc_b_id
  auto_accept = true

  tags = {
    Name = "VPC-Peering"
  }
}

# =========================
# ROUTE VPC A -> VPC B
# =========================
resource "aws_route" "a_to_b" {
  route_table_id            = var.route_table_a
  destination_cidr_block    = var.vpc_b_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

# =========================
# ROUTE VPC B -> VPC A
# =========================
resource "aws_route" "b_to_a" {
  route_table_id            = var.route_table_b
  destination_cidr_block    = var.vpc_a_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}