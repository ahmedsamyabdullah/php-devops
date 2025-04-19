######################################################################################################
                        #               Configure Network (VPC,Subnets,Nat,...etc)
######################################################################################################

# Define VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true           # Required for EKS
  enable_dns_support = true             # Required for EKS
  assign_generated_ipv6_cidr_block = false 

  tags = {
    Name = "Main VPC"
  }
}
#########################################
# Define IGW
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main IGW"
  }
}
########################################

# Define Security Group
resource "aws_security_group" "main"{
  vpc_id = aws_vpc.main.id
  name = "main-sg"

  ingress {
    description = "Allow SSH "
    from_port = 22 
    to_port = 22 
    protocol = "tcp"
    cidr_blocks = [ var.any_cidr ]
  }

  ingress{
    description = "Allow HTTP"
    from_port = 80 
    to_port = 80 
    protocol = "tcp"
    cidr_blocks = [ var.any_cidr ]
  }

  ingress {
    description = "Allow HTTPS"
    from_port = 443 
    to_port = 443 
    protocol = "tcp"
    cidr_blocks = [ var.any_cidr ]
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.any_cidr]
  }

  ingress {
    description = "SonarQube UI"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.any_cidr]
  }

  ingress {
    description = "Vault UI/API"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = [var.any_cidr]
  }




  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.any_cidr]
  } 
}

#########################################
# Note:=> We Will create 4-subnets = 2 public & 2 Private

###### TWO Public Subnets ###############

## public_subnet_1
resource "aws_subnet" "public_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_1_cidr
    availability_zone = var.az1
    map_public_ip_on_launch = true 

   tags = {
     Name = "Public Subnet 1"
    "kubernetes.io/cluster/eks"   = "shared"
    "kubernetes.io/role/elb"      = "1"
  }

}

## Public_subnet_2
resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_2_cidr         # Note:=> public_subnet_1 started from 192.168.0.0 to 192.168.63.255 (Last ip), then this subnet will start from 192.168.64.0
  availability_zone = var.az2
  map_public_ip_on_launch = true 

  tags = {
    Name = "Public Subnet 2"
    "kubernetes.io/cluster/eks"   = "shared"
    "kubernetes.io/role/elb"      = "1"

  }
}

###### Two Private Subnets ###############

## Private Subnet_1
resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_1_cidr
  availability_zone = var.az1         # Note:=> Public_1 & Private_1 inside in the same AZ
  map_public_ip_on_launch = false 

  tags = {
    Name = "Private Subnet 1"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

## Private Subnet_2
resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_2_cidr
  availability_zone = var.az2
  map_public_ip_on_launch = false 

  tags = {
    Name = "EKS Private_2"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

####################### Elastic ip address #############

# First eip
resource "aws_eip" "nat_1" {
  depends_on = [ aws_internet_gateway.main ]
}

# Second eip
resource "aws_eip" "nat_2" {
  depends_on = [ aws_internet_gateway.main ]
}

####################### Two Nat Gateway #############

# First nat
resource "aws_nat_gateway" "gw_1" {
  allocation_id = aws_eip.nat_1.id
  subnet_id = aws_subnet.public_1.id

  tags = {
    Name = "NAT 1"
  }
}

# Second nat
resource "aws_nat_gateway" "gw_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id = aws_subnet.public_2.id

  tags = {
    Name = "NAT 2"
  }
}

####################### Three Route Tables #############
# one RT for Public Subnet (one igw) & two RTs for private subnets(two nats)

# First RT for Public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route{
    cidr_block = var.any_cidr
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public RT"
  }
}

# Second RT for private_1 (nat1)
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.any_cidr
    nat_gateway_id = aws_nat_gateway.gw_1.id
  }

  tags = {
    Name = "Private_1 RT"
  }
}

# Third RT for private_2 (nat2)
resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.any_cidr
    nat_gateway_id = aws_nat_gateway.gw_2.id
  }

  tags = {
    Name = "Private_2 RT"
  }
}

#######################   Four Route Tables Associations #############
# Note:=> We will create 4 RT Associacion because we have 4 subnets

# First RT-ass public subnet_1
resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# Second RT-ass public subnet_2
resource "aws_route_table_association" "public_2" {
  subnet_id = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Third RT-ass private subnet_1
resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

# Fourth RT-ass private subnet_2
resource "aws_route_table_association" "private_2" {
  subnet_id = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}
