#userstable
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "users-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  tags = {
    Name        = "serverless-CRUD-terraform-project"
    Environment = "prod"
  }
}