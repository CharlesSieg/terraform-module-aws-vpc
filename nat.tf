# Workaround for interpolation not being able to "short-circuit" the evaluation of the conditional branch that doesn't end up being used
# Source: https://github.com/hashicorp/terraform/issues/11566#issuecomment-289417805
#
# The logical expression would be
#
#    nat_gateway_ips = var.reuse_nat_ips ? var.external_nat_ip_ids : aws_eip.nat.*.id
#
# but then when count of aws_eip.nat.*.id is zero, this would throw a resource not found error on aws_eip.nat.*.id.
locals {
  nat_gateway_ips = split(",", join(",", aws_eip.nat.*.id))
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? length(var.availability_zones) : 0
  tags  = merge(var.tags, { "Name" : format("%s-%s", var.name, element(var.availability_zones, count.index)) })
  vpc   = true
}

resource "aws_nat_gateway" "this" {
  allocation_id = element(local.nat_gateway_ips, count.index)
  count         = var.enable_nat_gateway ? length(var.availability_zones) : 0
  depends_on    = [aws_internet_gateway.this]
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  tags          = merge(var.tags, { "Name" : format("%s-%s", var.name, element(var.availability_zones, count.index)) })
}

