resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  tags   = merge(var.tags, { "Name" : format("%s-prv-%s", var.name, element(var.availability_zones, count.index)) })
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "private" {
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = var.private_subnets[count.index]
  count             = length(var.private_subnets)
  tags              = merge(var.tags, { "Name" : format("%s-prv-%s", var.name, element(var.availability_zones, count.index)) })
  vpc_id            = aws_vpc.this.id
}

resource "aws_route" "private_nat_gateway" {
  count                  = var.enable_nat_gateway ? length(var.private_subnets) : 0
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index)
  route_table_id         = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}
