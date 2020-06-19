# ---------------------------------------------------------------------------------------------------------------------
# AWS ROLES AND REGION
# ---------------------------------------------------------------------------------------------------------------------

variable "assume_role" {
  type        = string
  description = "(Required) The role to assume when doing an apply, defaults to ci"
  default     = "ci"
}

variable "vpc_region" {
  type        = string
  description = "(Required) The region the VPC we are deploying into is in, defaults to eu-west-2 (London)"
}

variable "costcode" {
  type    = string
  default = ""
}
