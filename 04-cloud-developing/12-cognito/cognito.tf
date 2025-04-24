resource "aws_cognito_user_pool" "lab_user_pool" {
  name = "the_cafe"
}

resource "aws_cognito_user_pool_domain" "lab_user_pool_domain" {
  user_pool_id          = aws_cognito_user_pool.lab_user_pool.id
  domain                = "cafeauth"
  managed_login_version = 1
}

resource "aws_cognito_user_pool_client" "lab_user_pool_client" {
  name         = "the_cafe_app_client"
  user_pool_id = aws_cognito_user_pool.lab_user_pool.id

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  logout_urls = [
    "https://d3rdbi1tcdqu2l.cloudfront.net/sign_out.html"
  ]
  callback_urls = [
    "https://d3rdbi1tcdqu2l.cloudfront.net/callback.html",
  ]
}

resource "aws_cognito_resource_server" "lab_resource_server" {
  name         = "cafe_resource_server"
  user_pool_id = aws_cognito_user_pool.lab_user_pool.id
  identifier   = "https://dnxtej0gjk.execute-api.us-east-1.amazonaws.com/prod/create_report"
}

resource "aws_cognito_user" "lab_cognito_user" {
  user_pool_id = aws_cognito_user_pool.lab_user_pool.id

  username           = "frank"
  temporary_password = "!CoffeeIsGreat34"
}
