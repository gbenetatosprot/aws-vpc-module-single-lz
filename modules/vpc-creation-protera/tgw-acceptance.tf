data "aws_ec2_transit_gateway" "shared" {
  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_ram_resource_association" "tgw" {
  count = var.tgw_share && var.ram_share_arn != "" ? 1 : 0

  resource_arn       = data.aws_ec2_transit_gateway.shared.id
  resource_share_arn = var.ram_share_arn

  lifecycle {
    ignore_changes = [resource_share_arn]
  }
}

resource "aws_ram_principal_association" "principals" {
  for_each = (
    var.tgw_share && var.ram_share_arn != "" && length(var.ram_principals) > 0
    ? toset(var.ram_principals)
    : {}
  )

  principal          = each.key
  resource_share_arn = var.ram_share_arn

  lifecycle {
    ignore_changes = [resource_share_arn]
  }
}