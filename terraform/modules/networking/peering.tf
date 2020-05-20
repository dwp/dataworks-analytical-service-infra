resource aws_vpc_peering_connection analytical-vpc {
  count       = length(regexall("^vpc-", var.analytical-env-vpc)) > 0 ? 1 : 0
  peer_vpc_id = var.analytical-env-vpc
  vpc_id      = var.vpc.id
  auto_accept = true
  tags        = merge(var.common_tags, { Name = "${var.name}-peering" })
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

data aws_vpc_peering_connection frontend {
  count       = length(regexall("^vpc-", var.analytical-env-vpc)) > 0 ? 1 : 0
  vpc_id      = var.vpc.id
  peer_vpc_id = var.analytical-env-vpc
}
