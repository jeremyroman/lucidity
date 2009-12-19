class EndpointRequirement < ActiveRecord::Base
  belongs_to :endpoint
  belongs_to :course_group
  
  def satisfied?(plan)
    (course_group.courses & plan.terms.map(&:courses).flatten).size >= self.number
  end
  
  def conflict_description
    "Endpoint #{endpoint.name} requires #{number} of: #{course_group.courses.map(&:code).join(', ')}"
  end
end
