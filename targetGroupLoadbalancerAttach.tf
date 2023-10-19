
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_lb_target_group_attachment" "instance" {
  count            = length(var.vzs)
  target_group_arn = aws_lb_target_group.targetgroup.arn
  target_id        = aws_instance.ec2[count.index].id
  port             = 80
}