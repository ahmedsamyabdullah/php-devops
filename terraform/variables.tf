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
#######################################

#### Define CIDR Block of any ip
variable "any_cidr" {
  description = "CIDR Block to define any ip add from anywhere"
  type = string
}

#######################################

# Define iam role variables
variable "ec2_role_name" {
  type = string
}

variable "ec2_profile_name" {
  type = string
}

##########################################

# Define ec2 instances vars
variable "ami" {
  description = "aws AMI for three ec2 instances, ubuntu ami"
  type = string
}

variable "instance_type" {
  description = "instance type for ec2 instances"
  type = string
}

variable "aws_key" {
  description = "aws key pair name"
  type = string
}

###############################################
# RDS PostgreSql vars
variable "db_username" {
  description = "DB username"
  type = string
  sensitive = true
}

variable "db_pass" {
  description = "DB user password"
  type = string
  sensitive = true
}

###################################################
#####    S3 & DynamoDB

variable "bucket_name" {
  description = "S3 bucket name for main_bucket to store terraform.tfstate file remotely"
  type = string
}

 