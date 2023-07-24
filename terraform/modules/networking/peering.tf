resource "aws_vpc_peering_connection" "analytical-vpc" {
  count       = length(regexall("^vpc-", var.analytical-env-vpc)) > 0 ? 1 : 0
  peer_vpc_id = var.vpc.id
  vpc_id      = var.analytical-env-vpc
  auto_accept = true
  tags        = merge(var.common_tags, { Name = "${var.name}-peering" })
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
}


data "aws_vpc" "frontend" {
  id = var.analytical-env-vpc
}
