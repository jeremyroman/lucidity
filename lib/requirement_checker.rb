class RequirementChecker
  attr_reader :course, :requirements, :term, :terms, :term_index, :codes
  
  def self.check(course, term)
    rc = RequirementChecker.new(term.plan)
    rc.course = course
    rc.term = term
    rc.check
  end
  
  def self.construct_requirement_objects(shorthand)
    case shorthand
    when Array
      RecursiveRequirement.new(shorthand)
    when Hash
      if shorthand.key?("prerequisite")
        Prerequisite.new(shorthand["prerequisite"])
      elsif shorthand.key?("antirequisite")
        Antirequisite.new(shorthand["antirequisite"])
      elsif shorthand.key?("corequisite")
        Corequisite.new(shorthand["corequisite"])
      else
        nil
      end
    end
  end
  
  def initialize(plan)
    @terms = plan.terms.find(:all, :include => :courses).to_a
    @codes = @terms.map { |t| t.courses.map(&:code) }
  end
  
  def course=(course)
    @course = course
    @requirements = course.requirements_data.map { |s| RequirementChecker.construct_requirement_objects(s) }.compact
  end
  
  def term=(term)
    @term = term
    @term_index = @terms.map(&:id).index(term.id)
  end
  
  def check
    result = []
    
    # Check that the course is offered that term
    unless @course.offered?(@term.season)
      result << Conflict.new(I18n.translate(:not_offered))
    end
    
    # Check that all requirements are satisfied
    @requirements.each do |r|
      t1 = Time.now
      unless r.satisfied?(self)
        message = I18n.translate(:requirement_not_satisfied, :requirement => r)
        result << Conflict.new(message)
      end
      Rails.logger.debug "\033[7m>> #{r} evaluated in #{Time.now - t1} seconds\033[0m"
    end
    
    result
  end
  
  class Conflict < Struct.new(:message)
    def to_s; message; end
  end
  
  class RecursiveRequirement
    def initialize(arr)
      if arr.first.is_a?(Numeric)
        @number, *@requirements = arr
      else
        @number, @requirements = nil, arr
      end
      
      @requirements = @requirements.map { |s| RequirementChecker.construct_requirement_objects(s) }.compact
    end
    
    def satisfied?(checker)
      if @number.nil?
        # All are needed
        @requirements.all? { |r| r.satisfied?(checker) }
        
      else
        # Only @number are needed
        @requirements.select { |r| r.satisfied?(checker) }.size >= @number
      end
    end
  end
  
  class Prerequisite
    def initialize(arr)
      if arr.first.is_a?(Numeric)
        @number, *@courses = arr
      else
        @number, @courses = nil, arr
      end
    end
    
    def terms_to_check(checker)
      0...checker.term_index
    end
    
    def satisfied?(checker)
      terms = terms_to_check(checker)
      
      if @number.nil?
        # All are needed
        @courses.all? do |course|
          code = course.is_a?(Hash) ? course['course'] : course
          checker.codes[terms].flatten.include?(code)
        end
        
      else
        # Only @number are needed
        @courses.select do |course|
          code = course.is_a?(Hash) ? course['course'] : course
          checker.codes[terms].flatten.include?(code)
        end.size >= @number
      end
    end
    
    def to_s
      if @number.nil?
        @courses.map { |course| course.is_a?(Hash) ? course['course'] : course}.to_sentence
      else
        "#{@number} of " + @courses.map { |course| course.is_a?(Hash) ? course['course'] : course}.to_sentence
      end
    end
  end
  
  class Corequisite < Prerequisite
    def terms_to_check(checker)
      0..checker.term_index
    end
    
    def to_s
      "Corequisite: #{super}"
    end
  end
  
  class Antirequisite < Prerequisite
    def terms_to_check(checker)
      0..checker.term_index
    end
    
    def satisfied?(checker)
      terms = terms_to_check(checker)
      
      not @courses.any? do |course|
        code = course.is_a?(Hash) ? course['course'] : course
        checker.codes[terms].flatten.include?(code)
      end
    end
    
    def to_s
      "Antirequisite: #{super}"
    end
  end
  
end