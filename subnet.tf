# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "subnets" {
  count                   = length(var.subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr[count.index]
  availability_zone       = var.vzs[count.index]
  map_public_ip_on_launch = true # Wir wollen, dass die Instanzen eine öffentliche IP bekommen

  tags = {
    Name = "TF Public ${var.vzs[count.index]}"
  }
}