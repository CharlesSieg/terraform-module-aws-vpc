#####################################################################
#####################################################################
# VPC
#####################################################################
#####################################################################

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Application = var.app_name
    Billing     = var.environment
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-vpc"
    Terraform   = true
  }
}

#####################################################################
#####################################################################
# PUBLIC
#####################################################################
#####################################################################

#
# Create the public subnets.
# One subnet will be created for each availability zone.
#
resource "aws_subnet" "public" {
  availability_zone       = element(var.availability_zones, count.index)
  cidr_block              = var.public_subnets[count.index]
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.this.id

  tags = {
    Application = var.app_name
    Billing     = var.environment
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-pub-subnet${count.index}"
    Terraform   = true
  }
}

#
# Create the public route table.
# If there are no public subnets, no public route table will be created.
#
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name      = "public-route-table"
    Terraform = true
  }
}

#
# Create the route table associations.
#
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

#####################################################################
#####################################################################
# INTERNET GATEWAY
#####################################################################
#####################################################################

#
# Create the Internet Gateway.
# If there are no public subnets, no IG will be created.
#
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Application = var.app_name
    Billing     = var.environment
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-ig"
    Terraform   = true
  }
}

#
# Create a route to the Internet in the public route table.
# If there are no public subnets, no route will be created.
#
resource "aws_route" "public_internet_route" {
  count                  = length(var.public_subnets) > 0 ? 1 : 0
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  route_table_id         = aws_route_table.public.id
}

#####################################################################
#####################################################################
# PRIVATE
#####################################################################
#####################################################################

#
# Create the private subnets.
# One subnet will be created for each availability zone.
#
resource "aws_subnet" "private" {
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = var.private_subnets[count.index]
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id

  tags = {
    Application = var.app_name
    Billing     = var.environment
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-prv-subnet${count.index}"
    Terraform   = true
  }
}

#
# Create the private route tables.
#
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name      = "private-route-table"
    Terraform = true
  }
}

#
# Create the route table associations.
#
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}
