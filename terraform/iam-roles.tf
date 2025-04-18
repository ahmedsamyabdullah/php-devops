##############################################################################
#                       IAM Roles
##############################################################################

# ec2 role
resource "aws_iam_role" "ec2_role" {
  name = var.ec2_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# ec2 S3 attachment
resource "aws_iam_role_policy_attachment" "ec2_s3_attach" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# ec2 ECR attach
resource "aws_iam_role_policy_attachment" "ec2_ecr_attach"{
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# eks policy attach
resource "aws_iam_role_policy_attachment" "eks_policy" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# vault secret attach
resource "aws_iam_role_policy_attachment" "vault_secrets_manager_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "vault_kms_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser"
}

# # ec2 profile
# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = var.ec2_profile_name
#   role = aws_iam_role.ec2_role.name

#     lifecycle {
#     # prevent_destroy = true
#     ignore_changes  = [name]
#   }
# }
