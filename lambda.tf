#iam role
resource "aws_iam_role" "iam_role_for_lambda" {
  name = "iamrole_for_lambda"

  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOT
}

#iam policies
resource "aws_iam_policy" "cloudWatchFullAccessPolicy" {
  name        = "CloudWatchLambda_Policy"
  description = " CloudWatch Full Access policy for Lambda"

    policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "autoscaling:Describe*",
          "cloudwatch:*",
          "logs:*",
          "sns:*",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole",
          "oam:ListSink"
        ]
        Resource = "*"
      },
      {
        Effect     = "Allow"
        Action     = "iam:CreateServiceLinkedRole"
        Resource   = "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*"
        Condition  = {
          StringLike: {
            "iam:AWSServiceName": "events.amazonaws.com"
          }
        }
      },
      {
        Effect   = "Allow"
        Action   = [
          "oam:ListAttachedLinks"
        ]
        Resource = "arn:aws:oam:*:*:sinks/*"
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodbFullAccessPolicy" {
  name        = "dynamodbLambda_Policy"
  description = " Dynamodb Full Access policy for Lambda"
  policy = jsonencode({
    Version="2012-10-17"
    Statement= [
        {
            Sid= "VisualEditor0"
            Effect= "Allow"
            Action= [
                "dynamodb:PutItem",
                "dynamodb:PartiQLSelect",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:Scan",
                "dynamodb:ListTagsOfResource",
                "dynamodb:UpdateItem",
                "dynamodb:DeleteTable",
                "dynamodb:ListStreams",
                "dynamodb:UpdateTable"
            ],
            Resource= "*"
        }
    ]
})
}

#iam role policy attachment
resource "aws_iam_role_policy_attachment" "cloudWatchLambdaAttach" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = aws_iam_policy.cloudWatchFullAccessPolicy.arn
}

resource "aws_iam_role_policy_attachment" "dynamodbLambdaAttach" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = aws_iam_policy.dynamodbFullAccessPolicy.arn
}

#invoking apigateway

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.serverless_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

#zipping lambda
data "archive_file" "zipLambda" {
  type        = "zip"
  output_path = "${path.module}/function/lambda_files.zip"
  source_dir  = "${path.module}/function/"
}

#lambda function
resource "aws_lambda_function" "serverless_lambda" {
  filename         = "${path.module}/function/lambda_files.zip"
  function_name    = "serverless-lambda-apigateway-2"
  role             = aws_iam_role.iam_role_for_lambda.arn
  handler          = "lambda_function.lambda_handler"
  depends_on       = [aws_iam_role_policy_attachment.cloudWatchLambdaAttach, aws_iam_role_policy_attachment.dynamodbLambdaAttach,]
  runtime          = "python3.9"
}


#outputs for testing if lambda is created with right role and policies
output "terraform_aws_role_output" {
  value = aws_iam_role.iam_role_for_lambda.name
}

output "terraform_aws_arn_output" {
  value = aws_iam_role.iam_role_for_lambda
}

output "terraform_logging_arn_output" {
  value = [aws_iam_policy.cloudWatchFullAccessPolicy.arn, aws_iam_policy.dynamodbFullAccessPolicy.arn]
}

