# Configure the AWS provider for the entire project.
provider "aws" {
  region = var.aws_region
}



# # Or if using LocalStack, configure the provider and endpoints!
# provider "aws" {
#   region                      = var.aws_region
#   access_key                  = "test"   # Dummy values for LocalStack
#   secret_key                  = "test"
#   skip_credentials_validation = true
#   skip_requesting_account_id  = true

#   endpoints {
#     ec2              = "http://localhost:4566"
#     iam              = "http://localhost:4566"
#     rds              = "http://localhost:4566"
#     lambda           = "http://localhost:4566"
#     s3               = "http://localhost:4566"
#     dynamodb         = "http://localhost:4566"
#     cloudwatch       = "http://localhost:4566"
#     autoscaling      = "http://localhost:4566"
#     elbv2            = "http://localhost:4566"
#   }
# }
