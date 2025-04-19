# Project : php-devops
## BY : Ahmed Samy
***
## I Created Terraform dir that contain  files infrastructure :
1. variables.tf
  - Define variables that we using in terraform files resources.
  - This file not contain the default values.

2. terraform.tfvars
  - Contained Values of Variables that defines in variables.tf

3. provider.tf 
  - Define AWS provider.
  - Set profile (php-devops) that contains my aws_credentials
  - Define region = us-east-2

4. network.tf
  - VPC 
  - IGW
  - Subnets (Public & Private)
  - EIP
  - NAT
  - Route Table
  - RT associate

5. iam-roles.tf
  - iam role for ec2
  
  - iam instance profile ec2

6. ec2.tf
  - Three ec2 instances
  - jenkins ec2
  - sonarqube ec2
  - vault ec2




* After finishing we run commands : 
- ```
    terraform init
  ```
<h5> To initialize provider & Backend </h5>

- ```
    terraform plan
  ```

- ```
    terraform apply
  ```
***
