variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "availability_zones" {
  default     = []
  description = "A list of availability zones in the region"
  type        = list(string)
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  default     = true
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
}

variable "enable_dns_support" {
  default     = true
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
}

variable "enable_nat_gateway" {
  default     = true
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
}

variable "environment" {
  description = "Name of environment being provisioned."
  type        = string
}

variable "map_public_ip_on_launch" {
  default     = true
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
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

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
}
