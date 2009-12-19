class Endpoint < ActiveRecord::Base
  has_many :endpoint_requirements
end
