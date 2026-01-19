resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "myigw"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

    tags = {
        Name = "publicSubnet${count.index + 1}"
    }
}

resource "aws_subnet" "my_private_subnet" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}


resource "aws_eip" "nat" {
  domain = "vpc"
  
  tags = {
    Name="mynatgateway"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id   # NAT must be in PUBLIC subnet

  depends_on = [aws_internet_gateway.igw]
    
    tags = {
        Name = "mynatgateway"
    }
}

# ---------------------------------------------
# PUBLIC ROUTE TABLE → Internet Gateway
# ---------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

# Associate all PUBLIC subnets with Public RT
resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# ---------------------------------------------
# PRIVATE ROUTE TABLE → NAT Gateway
# ---------------------------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
    tags = {
        Name = "private-rt"
    }
}

# Associate all PRIVATE subnets with Private RT
resource "aws_route_table_association" "private_assoc" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
