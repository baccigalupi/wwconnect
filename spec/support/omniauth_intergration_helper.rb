def linkedin_oauth_data
  {
    provider: 'linkedin',
    uid: '1010101'
  }
end

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new(linkedin_oauth_data)
