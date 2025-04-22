terraform {
  backend "s3" {
    profile = "php-devops"
    bucket = "samy-php-devops"
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "main_dynamodb"
    encrypt = true 
  }
}