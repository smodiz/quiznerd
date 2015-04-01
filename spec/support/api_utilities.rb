def token_auth_header(token)
  ActionController::HttpAuthentication::Token.encode_credentials(token)
end

def http_headers(token: nil)
  header = {
    'Accept' => 'application/json',
    'Content-Type' => 'application/json'
  }
  header['Authorization'] = token_auth_header(token) if token
  header
end

def it_has_status(status)
  it "has status #{status}" do
    expect_status(status)
  end
end

def expect_status(status)
  expect(response.status).to eq status
end

def it_has_json_response
  it "returns json content" do
    expect(response.content_type).to eq Mime::JSON
  end
end