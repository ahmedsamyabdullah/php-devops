
# Create S3 bucket to store terraform.tfstate
resource "aws_s3_bucket" "main_bucket" {
  bucket = var.bucket_name
 
  # lifecycle {
  #   prevent_destroy = true
  # }
  
  tags = {
    Name = "Samy PHP DevOps"
  }
}

# Create S3 bucket Versioning
resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create S3 bucket Server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main_bucket_encryption" {
  bucket = aws_s3_bucket.main_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create S3 bucket access block
resource "aws_s3_bucket_public_access_block" "main_bucket_block" {
  bucket = aws_s3_bucket.main_bucket.id
  block_public_acls = true 
  block_public_policy = true 
  ignore_public_acls = true 
  restrict_public_buckets = true 
  
}

# Create DynamoDB Table for State locking
resource "aws_dynamodb_table" "main_dynamodb" {
  name = "main_dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Main DynamoDB Table"
  }
}