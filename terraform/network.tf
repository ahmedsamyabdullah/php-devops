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