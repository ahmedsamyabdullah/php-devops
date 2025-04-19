##############################################################################################
#           Define Three ec2 instances (Jenkins, SonarQube, Vault)
##############################################################################################

# Get instance profile
data "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
}


# jenkins ec2
resource "aws_instance" "jenkins" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.aws_key
    iam_instance_profile = data.aws_iam_instance_profile.ec2_profile.name
    subnet_id = aws_subnet.public_1.id
    vpc_security_group_ids = [ aws_security_group.main.id ]
    associate_public_ip_address = true
    tags = {
      Name = "Jenkins"
    }
  
}

# sonarqube ec2
resource "aws_instance" "sonarqube" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.aws_key
    iam_instance_profile = data.aws_iam_instance_profile.ec2_profile.name
    subnet_id = aws_subnet.public_1.id
     vpc_security_group_ids = [ aws_security_group.main.id ]
    associate_public_ip_address = true

    tags = {
      Name = "SonarQube"
    }
  
}

# vault ec2
resource "aws_instance" "vault" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.aws_key
    iam_instance_profile = data.aws_iam_instance_profile.ec2_profile.name
    subnet_id = aws_subnet.public_1.id
    vpc_security_group_ids = [ aws_security_group.main.id ]
    associate_public_ip_address = true

    tags = {
      Name = "Vault"
    }
  
}
