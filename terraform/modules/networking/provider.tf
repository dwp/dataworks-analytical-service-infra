provider "aws" {
  alias = "cluster-broker"

  region  = var.region
  version = "~> 3.42.0"

  assume_role {
    role_arn = var.role_arn.cluster-broker
  }
}
