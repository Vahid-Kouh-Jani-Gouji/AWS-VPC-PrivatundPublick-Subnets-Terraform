# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "rt_associat" {
count = length(var.vzs)
 subnet_id      = element(aws_subnet.subnets.*.id, count.index)
  route_table_id = aws_route_table.rt.id
}