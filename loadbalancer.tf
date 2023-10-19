# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "application_loadbalancer" {
  name               = "loadbalancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  # subnets            = [for subnet in aws_subnet.subnet : subnet.id]
  subnets         = [aws_subnet.subnets[0].id, aws_subnet.subnets[1].id, aws_subnet.subnets[2].id]
  ip_address_type = "ipv4"

  tags = {
    Name = "My Load Balancer"
  }
}