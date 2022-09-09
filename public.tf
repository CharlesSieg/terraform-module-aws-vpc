resource "aws_internet_gateway" "this" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  tags   = merge(var.tags, { "Name" : format("%s", var.name) })
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  tags   = merge(var.tags, { "Name" : format("%s-pub", var.name) })
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "public_internet_gateway" {
  count                  = length(var.public_subnets) > 0 ? 1 : 0
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[count.index].id
  route_table_id         = aws_route_table.public[count.index].id
}

resource "aws_subnet" "public" {
  availability_zone       = element(var.availability_zones, count.index)
  cidr_block              = var.public_subnets[count.index]
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = merge(var.tags, { "Name" : format("%s-pub-%s", var.name, element(var.availability_zones, count.index)) })
  vpc_id                  = aws_vpc.this.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.public[0].id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

