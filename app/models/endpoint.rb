# Represents an endpoint (e.g. a degree or minor)
# and its requirements.
class Endpoint < ActiveRecord::Base
  has_many :endpoint_requirements, :dependent => :destroy 
  
  # Returns true if the plan satisfies all of the
  # endpoint requirements, and false otherwise.
  def satisfied?(plan)
    endpoint_requirements.all? { |er| er.satisfied?(plan) }
  end
  
  # Returns a list of conflicts with a given plan.
  # Each element will implement #conflict_description.
  def conflicts_with_plan(plan)
    endpoint_requirements.reject { |er| er.satisfied?(plan) }
  end
end
