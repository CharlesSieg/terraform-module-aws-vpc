output "private_subnets" {
  description = "A list of the IDs of the private subnets in the VPC."
  value       = aws_subnet.private.*.id
}

output "public_subnets" {
  description = "A list of the IDs of the public subnets in the VPC."
  value       = aws_subnet.public.*.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.this.id
}
