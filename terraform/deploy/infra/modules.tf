module analytical_service_infra_vpc {
  source  = "dwp/vpc/aws"
  version = "3.0.8"

  common_tags                              = local.common_tags
  gateway_vpce_route_table_ids             = module.networking.outputs.aws_route_table_private_ids
  interface_vpce_source_security_group_ids = []
  interface_vpce_subnet_ids                = module.networking.outputs.aws_subnets_private[*].id
  region                                   = var.vpc_region
  vpc_cidr_block                           = local.cidr_block[local.environment].analytical-service-infra-vpc
  vpc_name                                 = local.name

  aws_vpce_services = [
    "dynamodb",
    "ecrdkr",
    "ec2",
    "ec2messages",
    "glue",
    "kms",
    "logs",
    "monitoring",
    "s3",
    "emr",
    "ecs",
    "elasticloadbalancing"
  ]
}

module networking {
  source = "../../modules/networking"

  common_tags = local.common_tags
  name        = local.name

  region = var.vpc_region

  role_arn = {
    cluster-broker = "arn:aws:iam::${lookup(local.account, lookup(local.management_account, local.environment))}:role/${var.assume_role}"
  }

  vpc = {
    cidr_block          = module.analytical_service_infra_vpc.vpc.cidr_block
    id                  = module.analytical_service_infra_vpc.vpc.id,
    main_route_table_id = module.analytical_service_infra_vpc.vpc.main_route_table_id
  }

  internet_proxy_service_name = data.terraform_remote_state.internet_egress.outputs.internet_proxy_service.service_name
  analytical-env-vpc          = data.terraform_remote_state.aws_analytical_env_infra.outputs.vpc.aws_vpc.id
  analytical-env-vpc-subnets  = data.terraform_remote_state.aws_analytical_env_infra.outputs.vpc.aws_subnets_private
  analytical-env-route-tables = data.terraform_remote_state.aws_analytical_env_infra.outputs.vpc.aws_route_table_private_ids
}
