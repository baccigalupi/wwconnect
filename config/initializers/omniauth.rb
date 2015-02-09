Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin,
    Rails.application.secrets.linkedin_consumer_key,
    Rails.application.secrets.linkedin_consumer_secret
end
