# Model which represents a user and their associated resources

class User < ActiveRecord::Base
  has_many :plans
  
  # Returns a boolean indicating whether the user should
  # be granted administrative privileges.
  def admin?
    userid == 'jbroman'
  end
end
