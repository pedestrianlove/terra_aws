data "aws_api_gateway_rest_api" "lab_api_gateway" {
  name = "ProductsApi"
}

resource "aws_api_gateway_resource" "lab_api_gateway_resource" {
  rest_api_id = data.aws_api_gateway_rest_api.lab_api_gateway.id
  parent_id   = data.aws_api_gateway_rest_api.lab_api_gateway.root_resource_id
  path_part   = "bean_products"
}

resource "aws_api_gateway_method" "lab_api_gateway_method" {
  rest_api_id   = data.aws_api_gateway_rest_api.lab_api_gateway.id
  resource_id   = aws_api_gateway_resource.lab_api_gateway_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "lab_api_gateway_method_response" {
  rest_api_id = data.aws_api_gateway_rest_api.lab_api_gateway.id
  resource_id = aws_api_gateway_resource.lab_api_gateway_resource.id
  http_method = aws_api_gateway_method.lab_api_gateway_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration" "lab_api_gateway_integration" {
  rest_api_id             = data.aws_api_gateway_rest_api.lab_api_gateway.id
  resource_id             = aws_api_gateway_resource.lab_api_gateway_resource.id
  http_method             = aws_api_gateway_method.lab_api_gateway_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"

  uri = "${aws_elastic_beanstalk_environment.lab_beanstalk_env.endpoint_url}/beans.json"
}
