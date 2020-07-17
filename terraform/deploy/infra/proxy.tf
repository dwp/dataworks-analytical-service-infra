resource "aws_vpc_endpoint" "internet_proxy" {
  vpc_id              = module.networking.outputs.aws_vpc.id
  service_name        = data.terraform_remote_state.internet_egress.outputs.internet_proxy_service.service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.internet_proxy_endpoint.id]
  subnet_ids          = [module.networking.outputs.aws_subnets_private.0.id]
  private_dns_enabled = false

  tags = merge(
    local.common_tags,
    { Name = "internet-proxy" }
  )
}

resource "aws_security_group" "internet_proxy_endpoint" {
  name        = "proxy_vpc_endpoint"
  description = "Control access to the Internet Proxy VPC Endpoint"
  vpc_id      = module.networking.outputs.aws_vpc.id

  tags = merge(
    local.common_tags,
    { Name = "internet-proxy-endpoint" }
  )
}
