resource "aws_subnet" "pub_subnet" {
  vpc_id     = var.vpc-id
  for_each = var.subnet_cidr_block
  cidr_block = each.value
  availability_zone = each.key
  tags = {
    Name = "public_subnet_${each.key}"
  }
}

resource "aws_internet_gateway" "terrafom-igw" {
  vpc_id = var.vpc-id 

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "public_route_table" { 
  vpc_id = var.vpc-id
route {

   cidr_block = var.cidr_block_public_source

   gateway_id = aws_internet_gateway.terrafom-igw.id

 }
  tags = {
    Name = "pub_rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.pub_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

