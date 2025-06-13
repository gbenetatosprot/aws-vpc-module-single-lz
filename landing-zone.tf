################################################################################
# VPC Creation - SPOKE
################################################################################

module "vpc1" {
  source  = "./modules/vpc-creation-protera"

  name            = "bene-vpc-1"
  cidr            = "10.160.10.0/23"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.160.10.0/25", "10.160.11.0/25"]
  public_subnets  = ["10.160.10.128/26", "10.160.11.128/26"]
  staging_subnets = ["10.160.10.192/27"]

  private_subnet_names = ["Private-AZ1", "Private-AZ2"]
  public_subnet_names = ["Public-AZ1", "Public-AZ2"]
  staging_subnet_names = ["Staging-Subnet-AZ1-PRV"]

  enable_nat_gateway = false


  enable_dns_hostnames = true
  enable_dns_support   = true

  tgw_share = true

  ram_principals = [503659244423]
  ram_share_arn = "arn:aws:ram:us-east-1:706210432878:resource-share/2bc59596-8389-403c-af75-7f15d4351770"

  create_staging_subnet_route_table = true
}