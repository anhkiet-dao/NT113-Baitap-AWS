resource "aws_ec2_transit_gateway" "this" {
  description = "TGW for connecting VPC A, B, C"
  tags        = { Name = "Main-TGW" }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each           = var.vpc_attachments
  subnet_ids         = [each.value.subnet_id]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = each.value.vpc_id
  tags               = { Name = "Att-${each.key}" }
}