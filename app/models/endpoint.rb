# Represents an endpoint (e.g. a degree or minor)
# and its requirements.
class Endpoint < ActiveRecord::Base
  has_many :endpoint_requirements
  
  # Returns true if the plan satisfies all of the
  # endpoint requirements, and false otherwise.
  def satisfied?(plan)
    conflicts_with_plan(plan).empty?
  end
  
  # Returns a list of conflicts with a given plan.
  # Each element will implement #conflict_description.
  def conflicts_with_plan(plan)
    retval = []
    
    endpoint_requirements.each do |endpoint_requirement|
      retval << endpoint_requirement unless endpoint_requirement.satisfied?(plan)
    end
    
    retval
  end
end
