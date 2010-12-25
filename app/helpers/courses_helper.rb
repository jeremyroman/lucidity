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
        requirement.first
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
      
      elsif requirement.key?("not")
        rest = format_requirement(requirement["not"])
        "Not (#{rest})"
      
      elsif requirement.key?("program")
        "Program is #{requirement['program']}"
      end
    end
  end
end
