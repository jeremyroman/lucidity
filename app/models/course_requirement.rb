class CourseRequirement < ActiveRecord::Base
  belongs_to :course
  belongs_to :course_group
  
  def satisfied?(term, plan)
    course_group.courses.select do |course|
      term2 = plan.terms.detect { |t| t.courses.include? course }
      term2 && (term2.name < term.name)
    end.size >= number
  end
  
  def conflict_description
    "#{course.code} requires #{number} of: #{course_group.courses.map(&:code).join(', ')}"
  end
end
