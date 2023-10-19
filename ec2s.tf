# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "ec2" {
    count = length(var.vzs)
  ami                    = "ami-04e601abe3e1a910f"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = file("init.sh.tpl")


  tags = {
    name = "TF-test-a"
  }
}