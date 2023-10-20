# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# resource "aws_instance" "ec2" {
#   count                  = length(var.vzs)
#   ami                    = "ami-06dd92ecc74fdfb36"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.subnets[count.index].id
#   vpc_security_group_ids = [aws_security_group.sg.id]
#   user_data              = base64encode(templatefile("init.sh.tpl", { example = aws_vpc.main.id, subnet = aws_subnet.subnets[count.index].id }))


#   tags = {
#     name = "TF-test ${var.vzs[count.index]}"
#   }
# }