class Paths < Struct.new(:user)
  extend Forwardable

  def role_path_class
    return NullPaths unless user
    user.primary_role == Roles::RECRUITER ? RecruiterPaths : MemberPaths
  end

  def role_related_paths
    @role_related_paths ||= role_path_class.new(user)
  end

  def_delegators :role_related_paths, :home

  class MemberPaths < Struct.new(:user)
    def home
      "/member/jobs"
    end
  end

  class RecruiterPaths < Struct.new(:user)
    def home
      "/recruiters/#{user.id}/jobs"
    end
  end

  class NullPaths < Struct.new(:user)
    def home
      "/"
    end
  end
end
