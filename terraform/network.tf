/*
terraform/network.tf contains all the necessary resources to
setup the basis for our ECS application and AWS environment
Resources:
- Virtual Private Cloud
- Internet Gateway
- Route Table
- Public & Private Subnets
- Security Groups
*/

# availability zones in the region
data "aws_availability_zones" "azs" {}

# create a VPC (Virtual Private Cloud)
resource "aws_vpc" "fa-vpc" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true
  enable_dns_support    = true

  tags = {
    Name = "flask-app-vpc"
  }
}

# create an IGW (so resources can talk to the internet)
resource "aws_internet_gateway" "fa-igw" {
  vpc_id = aws_vpc.fa-vpc.id

  tags = {
    Name = "flask-app-igw"
  }
}

# create a Route Table for the VPC
resource "aws_route_table" "fa-rt-public" {
  vpc_id = aws_vpc.fa-vpc.id

  route {
    cidr_block = var.rt_wide_route
    gateway_id = aws_internet_gateway.fa-igw.id
  }

  tags = {
    Name = "flask-app-rt-public"
  }
}

# create a Default Route Table for the VPC
# (good practice -- anything not associated with the above
# RT will fall back into this one, so it's not just exposed)
resource "aws_default_route_table" "flask-postgres-private-default" {
  default_route_table_id = aws_vpc.fa-vpc.default_route_table_id

  tags = {
    Name = "flask-app-rt-private-default"
  }
}

# create <count> number of public subnets in each availability zone
resource "aws_subnet" "fa-public-subnets" {
  count = 2
  cidr_block = var.public_cidrs[count.index]
  vpc_id = aws_vpc.fa-vpc.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "flask-app-tf-public-${count.index + 1}"
  }
}

# create <count> number of private subnets in each availability zone
resource "aws_subnet" "fa-private-subnets" {
  count             = 2
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  vpc_id            = aws_vpc.fa-vpc.id

  tags = {
    Name = "flask-app-tf-private-${count.index + 1}"
  }
}


# associate the public subnets with the public route table
resource "aws_route_table_association" "fp-public-rt-assc" {
  count = 2
  route_table_id = aws_route_table.fa-rt-public.id
  subnet_id = aws_subnet.fa-public-subnets.*.id[count.index]
}

# associate the private subnets with the public route table
resource "aws_route_table_association" "fp-private-rt-assc" {
  count = 2
  route_table_id = aws_route_table.fa-rt-public.id
  subnet_id = aws_subnet.fa-private-subnets.*.id[count.index]
}

# create security group
resource "aws_security_group" "fa-public-sg" {
  name = "fa-public-group"
  description = "access to public instances"
  vpc_id = aws_vpc.fa-vpc.id
}
