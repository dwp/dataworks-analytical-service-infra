provider "aws" {
  alias = "cluster-broker"

  region  = var.region
  version = "~> 2.62.0"

  assume_role {
    role_arn = var.role_arn.cluster-broker
  }
}
