# Model which represents a user and their associated resources

class User < ActiveRecord::Base
  devise :cas_authenticatable, :trackable
  attr_accessible :username
  has_many :plans
  
  # Returns a boolean indicating whether the user should
  # be granted administrative privileges.
  def admin?
    username == 'jbroman'
  end
end
