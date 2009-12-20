class Plan < ActiveRecord::Base
  has_many :terms
  has_many :courses, :through => :terms
    
  def satisfies_endpoint?(endpoint)
    conflicts_with_endpoint(endpoint).empty?
  end
  
  def conflicts_with_endpoint(endpoint)
    retval = []
    
    endpoint.endpoint_requirements.each do |endpoint_requirement|
      retval << endpoint_requirement unless endpoint_requirement.satisfied?(self)
    end
    
    retval
  end
  
  def internally_consistent?
    internal_conflicts.empty?
  end
  
  def internal_conflicts
    retval = []
    
    terms.each do |term|
      term.courses.each do |course|
        retval << course unless course.offered.include?(term.season)
        
        course.course_requirements.each do |course_requirement|
          retval << course_requirement unless course_requirement.satisfied?(term, self)
        end
      end
    end
    
    retval
  end
  
  def print_internal_conflicts
    internal_conflicts.each { |con| puts con.conflict_description }
    nil
  end
  
  def print_conflicts_with_endpoint(endpoint)
    conflicts_with_endpoint(endpoint).each { |con| puts con.conflict_description }
    nil
  end
  
  def summ
    terms.each do |term|
      printf "%s/%s: ", term.name, term.season
      term.courses.each { |c| print c.code.ljust(10) }
      print "\n"
    end

    nil
  end
end
