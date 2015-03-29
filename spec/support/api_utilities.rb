def token_auth_header(token)
  ActionController::HttpAuthentication::Token.encode_credentials(token)
end

def basic_auth_header(username, password="")
  ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
end

def json_headers
  {
    'Accept' => 'application/json',
    'Content-Type' => 'application/json'
  }
end