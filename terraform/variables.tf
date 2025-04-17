###########################################################################################################################
# in this file we will only define variables name but not use (default), the values will pass through variables.tfvars file
#############################################################################################################################

# Define AWS Region
variable "aws_region" {
  description = "AWS Region where the resources will be created"
  type        = string
}

# Define CIDR Block for AWS VPC
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  type        = string
}

# CIDR Block for subnets
# Public subnet 1
variable "public_1_cidr" {
  type = string
}
# Public subnet 2
variable "public_2_cidr" {
  type = string
}
# private subnet 1
variable "private_1_cidr" {
  type = string
}
# private subnet 2
variable "private_2_cidr" {
  type = string
}

###################################
# Define AZs
variable "az1" {
  type = string
}

variable "az2" {
  type = string
}