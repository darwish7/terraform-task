resource "aws_subnet" "private_subnet" {
  vpc_id     = var.vpc-id
  for_each = var.subnet_cidr_block
  cidr_block = each.value
  availability_zone = each.key
  tags = {
    Name = "private_subnet_${each.key}"
  }
}

resource "aws_eip" "terrafom_elip" {
  vpc = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.terrafom_elip.id
  subnet_id = var.natgw_subnet
  tags = {
    Name = var.natgw_name
  }
}


resource "aws_route_table" "private" {
  vpc_id = var.vpc-id
  route {
    cidr_block = var.cidr_block_public_source
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.private.id
}

