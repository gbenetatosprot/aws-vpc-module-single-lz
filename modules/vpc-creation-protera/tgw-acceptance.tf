module "tgw_peer" {
  count = (
    var.tgw_share &&
    var.ram_share_arn != "" &&
    length(var.ram_principals) > 0
  ) ? 1 : 0

  source = "terraform-aws-modules/transit-gateway/aws"

  name            = "shared-tgw"
  description     = "My TGW shared with several other AWS accounts"

  create_tgw             = false
  share_tgw              = true
  ram_resource_share_arn = var.ram_share_arn
  enable_auto_accept_shared_attachments = true
  ram_allow_external_principals         = true
  ram_principals                        = var.ram_principals

}

data "aws_ec2_transit_gateway" "shared" {
  filter {
    name   = "state"
    values = ["available"]
  }
  depends_on = [aws_route_table_association.private]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-spoke" {
  count = (
    var.attachment_creation &&
    try(length(data.aws_ec2_transit_gateway.shared.id) > 0, false)
  ) ? 1 : 0

  subnet_ids                                            = aws_subnet.private[*].id
  transit_gateway_id                                    = data.aws_ec2_transit_gateway.shared.id
  transit_gateway_default_route_table_association       = false
  transit_gateway_default_route_table_propagation       = false
  vpc_id                                                = aws_vpc.this[0].id

  tags = {
    Name = "securityVPC-Attach"
  }
}
