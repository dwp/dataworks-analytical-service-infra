resource "aws_subnet" "private" {
  count                = local.zone_count
  cidr_block           = cidrsubnet(var.vpc.cidr_block, 4, count.index + local.zone_count + 1)
  vpc_id               = var.vpc.id
  availability_zone_id = data.aws_availability_zones.current.zone_ids[count.index]
  tags                 = merge(var.common_tags, { Name = "${var.name}-private-${local.zone_names[count.index]}" })
}

resource "aws_route_table" "private" {
  count  = local.zone_count
  vpc_id = var.vpc.id
  tags   = merge(var.common_tags, { Name = "${var.name}-private-${local.zone_names[count.index]}" })
}

resource "aws_route_table_association" "private" {
  count          = local.zone_count
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_route" "to_frontend" {
  count                     = length(regexall("^vpc-", var.analytical-env-vpc)) > 0 ? local.zone_count : 0
  route_table_id            = aws_route_table.private[count.index].id
  destination_cidr_block    = data.aws_vpc.frontend.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.analytical-vpc[0].id
}

resource "aws_route" "from_frontend" {
  count                     = length(regexall("^vpc-", var.analytical-env-vpc)) > 0 ? local.zone_count : 0
  route_table_id            = var.analytical-env-route-tables[count.index]
  destination_cidr_block    = var.vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.analytical-vpc[0].id
}



