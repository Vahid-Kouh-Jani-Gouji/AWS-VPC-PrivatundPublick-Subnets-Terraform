# Alle Locals werden innerhalb des locals Block definiert
locals {
  az_a = "${var.region}a" # eu-central-1a
  az_b = "${var.region}b"
  az_c = "${var.region}c"

  cidr_a = "10.0.1.0/24"
  cidr_b = "10.0.2.0/24"
  cidr_c = "10.0.3.0/24"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "TF VPC"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.cidr_a
  availability_zone = local.az_a
  map_public_ip_on_launch = true # Wir wollen, dass die Instanzen eine öffentliche IP bekommen

  tags = {
    Name = "TF Subnet A"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.cidr_b
  availability_zone = local.az_b
  map_public_ip_on_launch = true # Wir wollen, dass die Instanzen eine öffentliche IP bekommen

  tags = {
    Name = "TF Subnet B"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.cidr_c
  availability_zone = local.az_c
  map_public_ip_on_launch = true # Wir wollen, dass die Instanzen eine öffentliche IP bekommen

  tags = {
    Name = "TF Subnet c"
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "TF Internet Gateway"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Das gesamte Internet
    gateway_id = aws_internet_gateway.gw.id # Link zu unserem erstellten Internet Gateway
  }

  tags = {
    Name = "TF Route Table"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.rt.id
}
# -----------------------------------------------------------------------------------
# EC2 Instanz zum Testen des Setupt

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sg" {
  name = "tf_sg"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name="TF-SG"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "test" {
  ami           = "ami-065ab11fbd3d0323d"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    name="TF-test-a"
  }
}

resource "aws_instance" "test-b" {
  ami           = "ami-065ab11fbd3d0323d"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_b.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    name="TF-test-b"
  }
}

resource "aws_instance" "test-c" {
  ami           = "ami-065ab11fbd3d0323d"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_c.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    name="TF-test-c"
  }
}

# Erstelle jetzt in jedem AZ ein weiteres privates Subnetz. Verwende hierfür ein Nat Gateway.

# Nat Gateway in AZ A
resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.subnet_a.id
  tags = {
    name="TF-nat-a"
  }
}

# Elastic IP für NAT Gateway in AZ A
resource "aws_eip" "nat_a" {
  domain           = "vpc"
}

# Route Table für privates Subnetz in AZ A
resource "aws_route_table" "private_rt_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }
}

# Subnetz in AZ A für private Instanzen
resource "aws_subnet" "subnet_a_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24" # Passen Sie die CIDR-Block-Definition entsprechend an
  availability_zone = local.az_a
  map_public_ip_on_launch = false # Keine öffentlichen IPs für private Subnetze

  tags = {
    Name = "TF Subnet A (Private)"
  }
}

resource "aws_route_table_association" "private_rt_a" {
  subnet_id      = aws_subnet.subnet_a_private.id
  route_table_id = aws_route_table.private_rt_a.id
}



# Nat Gateway in AZ B
resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.subnet_b.id
}

# Elastic IP für NAT Gateway in AZ B
resource "aws_eip" "nat_b" {
  domain           = "vpc"
}

# Route Table für privates Subnetz in AZ B
resource "aws_route_table" "private_rt_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_b.id
  }
}

# Subnetz in AZ B für private Instanzen
resource "aws_subnet" "subnet_b_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.5.0/24" # Passen Sie die CIDR-Block-Definition entsprechend an
  availability_zone = local.az_b
  map_public_ip_on_launch = false

  tags = {
    Name = "TF Subnet B (Private)"
  }
}

resource "aws_route_table_association" "private_rt_b" {
  subnet_id      = aws_subnet.subnet_b_private.id
  route_table_id = aws_route_table.private_rt_b.id
}

# Wiederholen Sie die oben genannten Schritte für die AZ C, um private Subnetze und NAT Gateways in AZ C zu erstellen.

# Beachten Sie, dass Sie auch die Sicherheitsgruppen für die privaten Instanzen entsprechend konfigurieren müssen, um den Kommunikationsbedarf zu erfüllen.

# Stellen Sie sicher, dass Sie die Variablen und andere Konfigurationen entsprechend anpassen, um Ihre speziellen Anforderungen und Präferenzen zu berücksichtigen.

resource "aws_nat_gateway" "nat_c" {
  allocation_id = aws_eip.nat_c.id
  subnet_id     = aws_subnet.subnet_c.id
}

# Elastic IP für NAT Gateway in AZ c
resource "aws_eip" "nat_c" {
  domain           = "vpc"
}

# Route Table für privates Subnetz in AZ c
resource "aws_route_table" "private_rt_c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_c.id
  }
}

# Subnetz in AZ c für private Instanzen
resource "aws_subnet" "subnet_c_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.6.0/24" # Passen Sie die CIDR-Block-Definition entsprechend an
  availability_zone = local.az_c
  map_public_ip_on_launch = false

  tags = {
    Name = "TF Subnet B (Private)"
  }
}

resource "aws_route_table_association" "private_rt_c" {
  subnet_id      = aws_subnet.subnet_c_private.id
  route_table_id = aws_route_table.private_rt_c.id
}
