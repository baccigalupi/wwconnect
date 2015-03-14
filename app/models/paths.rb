class Paths < Struct.new(:authentication)
  extend Forwardable

  def role_path_class
    return NullPaths unless authentication
    authentication.primary_role == Role::RECRUITER ? RecruiterPaths : MemberPaths
  end

  def role_related_paths
    @role_related_paths ||= role_path_class.new(authentication)
  end

  def_delegators :role_related_paths, :home

  class MemberPaths < Struct.new(:authentication)
    def home
      "/members/#{authentication.id}/jobs"
    end
  end

  class RecruiterPaths < Struct.new(:authentication)
    def home
      "/recruiters/#{authentication.id}/jobs"
    end
  end

  class NullPaths < Struct.new(:authentication)
    def home
      "/"
    end
  end
end
