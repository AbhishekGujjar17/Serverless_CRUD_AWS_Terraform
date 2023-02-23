#restapi
resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  name        = "MyDemoAPI"
  description = "Serverless api gateway for CRUD operations with Lambda and DyanmoDb"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#/health
resource "aws_api_gateway_resource" "health" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = "health"
}

#/user
resource "aws_api_gateway_resource" "user" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = "user"
}

#/users
resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = "users"
}

#methods
resource "aws_api_gateway_method" "healthGetMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.health.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required  = false
}

resource "aws_api_gateway_method" "healthOptionsMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.health.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  api_key_required  = false
}

resource "aws_api_gateway_method" "usersGetMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required  = false
}

resource "aws_api_gateway_method" "usersOptionsMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  api_key_required  = false
}

resource "aws_api_gateway_method" "userGetMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required  = false
}

resource "aws_api_gateway_method" "userPostMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required  = false
}

resource "aws_api_gateway_method" "userPatchMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "PATCH"
  authorization = "NONE"
  api_key_required  = false
}

resource "aws_api_gateway_method" "userDeleteMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "DELETE"
  authorization = "NONE"
  api_key_required  = false
}

resource "aws_api_gateway_method" "userOptionsMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  api_key_required  = false
}

#integratiion
resource "aws_api_gateway_integration" "healthLambdaIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id             = aws_api_gateway_resource.health.id
  http_method             = aws_api_gateway_method.healthGetMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "healthOptionsLambdaIntegration" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.health.id
  http_method = aws_api_gateway_method.healthOptionsMethod.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "usersLambdaIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id             = aws_api_gateway_resource.users.id
  http_method             = aws_api_gateway_method.usersGetMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "usersOptionsLambdaIntegration" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.usersOptionsMethod.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "userGetLambdaIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id             = aws_api_gateway_resource.user.id
  http_method             = aws_api_gateway_method.userGetMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "userPostLambdaIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id             = aws_api_gateway_resource.user.id
  http_method             = aws_api_gateway_method.userPostMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "userDeleteLambdaIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id             = aws_api_gateway_resource.user.id
  http_method             = aws_api_gateway_method.userDeleteMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "userPatchLambdaIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id             = aws_api_gateway_resource.user.id
  http_method             = aws_api_gateway_method.userPatchMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "userOptionsLambdaIntegration" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.userOptionsMethod.http_method
  type        = "MOCK"
}

#api deployment

resource "aws_api_gateway_deployment" "MyDemoAPIDeployment" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.MyDemoAPI.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_integration.healthLambdaIntegration,aws_api_gateway_integration.healthOptionsLambdaIntegration,aws_api_gateway_integration.usersLambdaIntegration,aws_api_gateway_integration.usersOptionsLambdaIntegration,aws_api_gateway_integration.userGetLambdaIntegration,aws_api_gateway_integration.userPatchLambdaIntegration,aws_api_gateway_integration.userPostLambdaIntegration,aws_api_gateway_integration.userDeleteLambdaIntegration,aws_api_gateway_integration.userOptionsLambdaIntegration]
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.MyDemoAPIDeployment.id
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  stage_name    = "prod"
}




