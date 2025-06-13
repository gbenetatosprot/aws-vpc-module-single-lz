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