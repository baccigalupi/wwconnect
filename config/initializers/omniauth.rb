Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin,
    Envar.linkedin_consumer_key,
    Envar.linkedin_consumer_secret,
    scope: 'r_fullprofile r_emailaddress r_network'
end
