data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name             = "${local.project_name}-VPC"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = "${aws_vpc.vpc.id}"

  tags      = {
    Name    = "${local.project_name}-InternetGateway"
  }
}

resource "aws_eip" "nat" {
  count   = length(data.aws_availability_zones.available.names)
  vpc     = true

  tags    = {
    Name  = "${local.project_name}-EIP-${1+count.index}"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  count         = length(data.aws_availability_zones.available.names)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  depends_on    = [aws_internet_gateway.internet_gateway]

  tags = {
    Name        = "${local.project_name}-NatGateway-${1+count.index}"
 
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${substr(local.vpc_cidr, 0, 6)}${101+count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name                  = "${local.project_name}-Public-Subnet-${1+count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${substr(local.vpc_cidr, 0, 6)}${1+count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name                  = "${local.project_name}-Private-Subnet-${1+count.index}"
  }
}


# Routing table for public subnets
resource "aws_route_table" "route_table_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${local.project_name}-RouteTable-Public"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "route_table_public_association" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.route_table_public.*.id, count.index)
}



resource "aws_route_table" "route_table_private" {
  count  = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${local.project_name}-RouteTable-Private-${1+count.index}"
  }
}

resource "aws_route" "private" {
  count                  = length(data.aws_availability_zones.available.names)
  route_table_id         = element(aws_route_table.route_table_private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat_gateway.*.id, count.index)
}

resource "aws_route_table_association" "route_table_private_association" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.route_table_private.*.id, count.index)

}


