class AuthenticationUpdater < Struct.new(:data, :param_role)
  def perform
    return unless authentication
    update_roles
    authentication
  end

  def role
    Role.valid?(param_role) ? param_role : Role::MEMBER
  end

  def authentication
    @authentication ||= AuthenticationRepository.new({
      attrs: ::LinkedInAuthenticationParser.new(data).attrs
    }).save
  end

  def update_roles
    return if authentication.roles.map(&:type).include?(role)
    authentication.roles.create(type: role)
  end

  class AuthenticationRepository < Repository
    def persistence_class
      Authentication
    end

    def record
      @record ||= persistence_class.where(email: attrs[:email]).take ||
                  persistence_class.where(uid: attrs[:uid]).take
    end
  end
end
