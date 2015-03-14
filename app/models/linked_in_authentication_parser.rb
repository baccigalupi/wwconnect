class LinkedInAuthenticationParser
  attr_reader :oauth_data

  def initialize(oauth_data)
    @oauth_data = oauth_data
    normalize_data
  end

  def normalize_data
    oauth_data.info           ||= null_data
    oauth_data.info.location  ||= null_data
    oauth_data.info.urls      ||= null_data
    oauth_data.credentials    ||= null_data
  end

  def null_data
    Hashie::Mash.new
  end

  def attrs
    {
      first_name:   oauth_data.info.first_name,
      last_name:    oauth_data.info.last_name,
      uid:          oauth_data.uid,
      provider:     oauth_data.provider,
      email:        oauth_data.info.email,
      title:        oauth_data.info.description,
      location:     oauth_data.info.location.name,
      image:        oauth_data.info.image,
      linkedin_url: oauth_data.info.urls.public_profile,
      token:        oauth_data.credentials.token,
      expires_at:   expires_at
    }
  end

  def expires_at
    return unless oauth_data.credentials.expires_at
    Time.at(oauth_data.credentials.expires_at)
  end
end
