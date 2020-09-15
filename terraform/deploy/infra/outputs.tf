output vpc {
  value = module.networking.outputs
}

output interface_vpce_sg_id {
  value = module.analytical_service_infra_vpc.interface_vpce_sg_id
}

output s3_prefix_list_id {
  value = module.analytical_service_infra_vpc.prefix_list_ids.s3
}

output dynamodb_prefix_list_id {
  value = module.analytical_service_infra_vpc.prefix_list_ids.dynamodb
}
