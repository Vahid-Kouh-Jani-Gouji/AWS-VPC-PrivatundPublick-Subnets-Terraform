









# # Erstelle jetzt in jedem AZ ein weiteres privates Subnetz. Verwende hierfür ein Nat Gateway.

# # Nat Gateway in AZ A
# resource "aws_nat_gateway" "nat_a" {
#   allocation_id = aws_eip.nat_a.id
#   subnet_id     = aws_subnet.subnet_a.id
#   tags = {
#     name="TF-nat-a"
#   }
# }

# # Elastic IP für NAT Gateway in AZ A
# resource "aws_eip" "nat_a" {
#   domain           = "vpc"
# }

# # Route Table für privates Subnetz in AZ A
# resource "aws_route_table" "private_rt_a" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_a.id
#   }
# }

# # Subnetz in AZ A für private Instanzen
# resource "aws_subnet" "subnet_a_private" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.4.0/24" 
#   availability_zone = local.az_a
#   map_public_ip_on_launch = false # Keine öffentlichen IPs für private Subnetze

#   tags = {
#     Name = "TF Subnet A (Private)"
#   }
# }

# resource "aws_route_table_association" "private_rt_a" {
#   subnet_id      = aws_subnet.subnet_a_private.id
#   route_table_id = aws_route_table.private_rt_a.id
# }



# # Nat Gateway in AZ B
# resource "aws_nat_gateway" "nat_b" {
#   allocation_id = aws_eip.nat_b.id
#   subnet_id     = aws_subnet.subnet_b.id
# }

# # Elastic IP für NAT Gateway in AZ B
# resource "aws_eip" "nat_b" {
#   domain           = "vpc"
# }

# # Route Table für privates Subnetz in AZ B
# resource "aws_route_table" "private_rt_b" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_b.id
#   }
# }

# # Subnetz in AZ B für private Instanzen
# resource "aws_subnet" "subnet_b_private" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.5.0/24" 
#   availability_zone = local.az_b
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "TF Subnet B (Private)"
#   }
# }

# resource "aws_route_table_association" "private_rt_b" {
#   subnet_id      = aws_subnet.subnet_b_private.id
#   route_table_id = aws_route_table.private_rt_b.id
# }


# resource "aws_nat_gateway" "nat_c" {
#   allocation_id = aws_eip.nat_c.id
#   subnet_id     = aws_subnet.subnet_c.id
# }

# # Elastic IP für NAT Gateway in AZ c
# resource "aws_eip" "nat_c" {
#   domain           = "vpc"
# }

# # Route Table für privates Subnetz in AZ c
# resource "aws_route_table" "private_rt_c" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_c.id
#   }
# }

# # Subnetz in AZ c für private Instanzen
# resource "aws_subnet" "subnet_c_private" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.6.0/24" 
#   availability_zone = local.az_c
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "TF Subnet B (Private)"
#   }
# }

# resource "aws_route_table_association" "private_rt_c" {
#   subnet_id      = aws_subnet.subnet_c_private.id
#   route_table_id = aws_route_table.private_rt_c.id
# }
