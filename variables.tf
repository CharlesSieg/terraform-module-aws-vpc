variable "app_name" {
  description = "The app name used for tagging infrastructure."
  type        = string
}

variable "availability_zones" {
  description = "A list of availability zones in the region"
  type        = list(string)
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "environment" {
  description = "The environment in which this infrastructure will be provisioned."
  type        = string
}

variable "private_subnets" {
  default     = []
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

variable "public_subnets" {
  default     = []
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}
