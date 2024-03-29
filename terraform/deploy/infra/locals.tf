data "aws_secretsmanager_secret_version" "internet_ingress" {
  provider  = aws.ssh_bastion
  secret_id = "/concourse/dataworks/internet-ingress"
}

data "aws_secretsmanager_secret_version" "terraform_secrets" {
  provider  = aws.management_dns
  secret_id = "/concourse/dataworks/terraform"
}

locals {
  deploy_ithc_infra = {
    development = false
    qa          = false
    integration = false
    preprod     = false
    production  = false
  }

  env_prefix = {
    development = "dev."
    qa          = "qa."
    stage       = "stg."
    integration = "int."
    preprod     = "pre."
    production  = ""
  }

  dw_domain = "${local.env_prefix[local.environment]}dataworks.dwp.gov.uk"

  kali_users = jsondecode(data.aws_secretsmanager_secret_version.internet_ingress.secret_binary)["ssh_bastion_users"]

  # Configured as per Tagging doc requirements https://engineering.dwp.gov.uk/policies/hcs-cloud-hosting-policies/resource-identification-tagging/
  # Also required as per Tenable documentation https://engineering.dwp.gov.uk/products/gold-images/agents/tenable/
  hcs_environment = {
    development    = "Dev"
    qa             = "Test"
    integration    = "Stage"
    preprod        = "Stage"
    production     = "Production"
    management     = "SP_Tooling"
    management-dev = "DT_Tooling"
  }
  tanium_service_name = {
    development = jsondecode(data.aws_secretsmanager_secret_version.terraform_secrets.secret_binary).tanium.service_name.non_prod
    qa          = jsondecode(data.aws_secretsmanager_secret_version.terraform_secrets.secret_binary).tanium.service_name.prod
    integration = jsondecode(data.aws_secretsmanager_secret_version.terraform_secrets.secret_binary).tanium.service_name.prod
    preprod     = jsondecode(data.aws_secretsmanager_secret_version.terraform_secrets.secret_binary).tanium.service_name.prod
    production  = jsondecode(data.aws_secretsmanager_secret_version.terraform_secrets.secret_binary).tanium.service_name.prod
  }
}
