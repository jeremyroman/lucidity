# Specifies requirements (e.g. prerequisites) for completion
# of an endpoint.
class EndpointRequirement < ActiveRecord::Base
  belongs_to :endpoint
  belongs_to :course_group, :dependent => :destroy
  
  # Returns true is the requirement is satisfied by the plan given
  # and false otherwise.
  def satisfied?(plan)
    (course_group.courses & plan.terms.map(&:courses).flatten).size >= self.number
  end
  
  # Returns a description of the conflict (that is, that
  # the requirement is not satisfied)
  def conflict_description(style=:long)
    case style
    when :long
      "Endpoint #{endpoint.name} #{conflict_description(:short)}"
    when :short
      "requires #{number} of: #{course_group.courses.map(&:code).join(', ')}"
    end
  end
end
