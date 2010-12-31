module CoursesHelper
  def format_requirement(requirement)
    case requirement
    when String
      requirement
      
    when Array
      if requirement.first.is_a?(Numeric)
        number = requirement.first
        requirement = requirement[1..-1]
      else
        number = nil
      end
      
      group = requirement.map { |r| format_requirement(r) }
      
      if requirement.size == 1
        group.first
      elsif number == 1
        "(" + group.to_sentence(:two_words_connector => " or ", :last_word_connector => " or ") + ")"
      elsif number
        "(#{requirement.first} of " + group.to_sentence + ")"
      else
        "(" + group.to_sentence + ")"
      end
      
    when Hash
      if requirement.key?("prerequisite")
        rest = format_requirement(requirement["prerequisite"])
        rest
      
      elsif requirement.key?("corequisite")
        rest = format_requirement(requirement["corequisite"])
        Rails.logger.debug("Corequisite: #{rest}")
        "Corequisite: #{rest}"
      
      elsif requirement.key?("antirequisite")
        rest = format_requirement(requirement["antirequisite"])
        Rails.logger.debug("Antirequisite: #{rest}")
        "Antirequisite: #{rest}"
      
      elsif requirement.key?("not")
        rest = format_requirement(requirement["not"])
        "Not (#{rest})"
      
      elsif requirement.key?("program")
        "Program is #{requirement['program']}"
        
      elsif requirement.key?("min-mark")
        "#{requirement['course']}: >= #{requirement['min-mark']}%"
      end
    end
  end
end
