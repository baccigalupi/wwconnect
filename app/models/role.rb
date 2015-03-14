class Role < ActiveRecord::Base
  MEMBER = 'member'
  RECRUITER = 'recruiter'
  
  belongs_to :authentication

  def self.valid?(role)
    role == MEMBER || role == RECRUITER
  end
end
