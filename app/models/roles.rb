module Roles
  MEMBER = 'member'
  RECRUITER = 'recruiter'

  def self.valid?(role)
    role == MEMBER || role == RECRUITER
  end
end
