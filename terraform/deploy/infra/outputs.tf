output vpc {
  value = module.networking.outputs
}

output interface_vpce_sg_id {
  value = module.analytical_service_infra_vpc.interface_vpce_sg_id
}

output s3_prefix_list_id {
  value = module.analytical_service_infra_vpc.s3_prefix_list_id
}

output dynamodb_prefix_list_id {
  value = module.analytical_service_infra_vpc.dynamodb_prefix_list_id
}