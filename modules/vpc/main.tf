#########################################################
# VPC and Subnet configuration
#########################################################

# Create the VPC.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MultiTier-VPC"
  }
}

# Create an Internet Gateway for public subnet access.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MultiTier-IGW"
  }
}

# Fetch availability zones.
data "aws_availability_zones" "available" {}

# Create public subnets.
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "MultiTier-PublicSubnet-${count.index + 1}"
  }
}

# Create private subnets.
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "MultiTier-PrivateSubnet-${count.index + 1}"
  }
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MultiTier-Public-RT"
  }
}

# Add a route for Internet access in the public RT.
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Associate each public subnet with the public route table.
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#########################################################
# NAT Gateway & Private Subnet Routing (Option B)
#########################################################

# Allocate an Elastic IP for the NAT Gateway.
resource "aws_eip" "nat" {
  domain = "vpc" # replaced deprecated vpc = true

  tags = {
    Name = "MultiTier-NAT-EIP"
  }
}

# Create the NAT Gateway in the first public subnet.
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "MultiTier-NAT-GW"
  }

  # Ensure the IGW is created before the NAT
  depends_on = [aws_internet_gateway.gw]
}

# Create a route table for private subnets.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MultiTier-Private-RT"
  }
}

# Add default route for private subnets to the NAT Gateway.
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Associate each private subnet with the private route table.
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
