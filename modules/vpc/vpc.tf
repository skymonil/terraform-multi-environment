resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
    ManagedBy = "Terraform"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet-gateway-${var.environment}"
  }
}

resource "aws_subnet" "public_subnets" {
vpc_id = aws_vpc.main.id  
count = length(var.availability_zones)
cidr_block = var.public_subnet_cidrs[count.index]
availability_zone = var.availability_zones[count.index]
map_public_ip_on_launch = true

tags = {
  Name = "public-${var.region}-${var.availability_zones[count.index]}-${var.environment}"
  ManagedBy = "Terraform"
}


}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.main.id

  count = var.enable_private_subnets ? 2 : 0

  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

 tags = {
 Name = "private-${var.region}-${var.availability_zones[count.index]}-${var.environment}"
  ManagedBy = "Terraform"
}
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public-rt-${var.environment}"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table" "private_route_table" {
  count  = var.enable_private_subnets ? 2 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name      = "private-rt-${count.index}-${var.environment}"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table_association" "public_route_table_associations" {
  count = length(var.availability_zones)
  subnet_id = element(aws_subnet.public_subnets[*].id,count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_associations" {
 count = var.enable_private_subnets ? length(var.availability_zones) : 0

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id

}

resource "aws_eip" "eip_natgw" {
  count  = 2
  domain = "vpc"

}

resource "aws_nat_gateway" "nat_gateway" {

  count = var.enable_nat? 2: 0 


  allocation_id = aws_eip.eip_natgw[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name      = "nat-gw-${count.index}-${var.environment}"
    ManagedBy = "Terraform"
  }

  depends_on = [aws_internet_gateway.internet_gateway, aws_eip.eip_natgw]
}


