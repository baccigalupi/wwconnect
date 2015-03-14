class LinkedInAuthenticationParser
  attr_reader :oauth_data

  def initialize(oauth_data)
    @oauth_data = oauth_data
    normalize_data
  end

  def normalize_data
    oauth_data.info ||= Hashie::Mash.new
    oauth_data.info.location ||= Hashie::Mash.new
    oauth_data.info.urls ||= Hashie::Mash.new
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
      linkedin_url: oauth_data.info.urls.public_profile
    }
  end
end
