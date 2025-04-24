data "aws_api_gateway_rest_api" "lab_api_gateway_restapi" {
  name = "ProductsApi"
}

resource "aws_api_gateway_authorizer" "lab_api_gateway_auth" {
  name        = "cafe_lockdown"
  rest_api_id = data.aws_api_gateway_rest_api.lab_api_gateway_restapi.id

  type = "COGNITO_USER_POOLS"
  provider_arns = [
    aws_cognito_user_pool.lab_user_pool.arn
  ]
}
