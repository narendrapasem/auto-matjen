
//vpc
resource "aws_vpc" "lenin-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name      = "lenin-vpc"
    Terraform = "True"
  }
}
//subnets
resource "aws_subnet" "leninsubpub" {
  vpc_id                  = aws_vpc.lenin-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  //availability_zone = data.aws_availability_zone
  tags = {
    Name = "leninsubpub"

  }
}

resource "aws_subnet" "leninsubpri" {
  vpc_id     = aws_vpc.lenin-vpc.id
  cidr_block = "10.0.2.0/24"
  //availability_zone = data.aws_availability_zone
  tags = {
    Name = "leninsubpri"
  }
}

//internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lenin-vpc.id

  tags = {
    Name = "igw"
  }
  depends_on = [
    aws_vpc.lenin-vpc
  ]
}
//eip
resource "aws_eip" "eip" {
  vpc = true
  tags = {
    "Name" = "lenineip"
  }
}
//nat gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.leninsubpub.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip]
}
//routes
resource "aws_route_table" "leninpubrt" {
  vpc_id = aws_vpc.lenin-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "leninpubrt"
  }
}

resource "aws_route_table" "leninprirt" {
  vpc_id = aws_vpc.lenin-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "leninprirt"
  }
}
//association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.leninsubpub.id
  route_table_id = aws_route_table.leninpubrt.id
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.leninsubpri.id
  route_table_id = aws_route_table.leninprirt.id
}

