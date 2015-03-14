class Authentication < ActiveRecord::Base
  has_many :roles, -> { order "created_at ASC" }

  def primary_role
    role = roles.first
    role.type if role
  end
end
