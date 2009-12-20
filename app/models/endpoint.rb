# Represents an endpoint (e.g. a degree or minor)
# and its requirements.
class Endpoint < ActiveRecord::Base
  has_many :endpoint_requirements
end
