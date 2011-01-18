module CoursesHelper
  def format_requirement(requirement, use_brackets = false)
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

      group = requirement.map { |r| format_requirement(r, true) }

      if requirement.size == 1
        return group.first
      end

      result = if number == 1
        group.to_sentence(:two_words_connector => " or ", :last_word_connector => " or ")
      elsif number
        requirement.first + " of " + group.to_sentence
      else
        group.to_sentence
      end

      use_brackets ? "(#{result})" : result

    when Hash
      if requirement.key?("prerequisite")
        rest = format_requirement(requirement["prerequisite"], use_brackets)
        rest

      elsif requirement.key?("corequisite")
        rest = format_requirement(requirement["corequisite"], use_brackets)
        Rails.logger.debug("Corequisite: #{rest}")
        "Corequisite: #{rest}"

      elsif requirement.key?("antirequisite")
        rest = format_requirement(requirement["antirequisite"], use_brackets)
        Rails.logger.debug("Antirequisite: #{rest}")
        "Antirequisite: #{rest}"

      elsif requirement.key?("not")
        rest = format_requirement(requirement["not"], true)
        "Not (#{rest})"

      elsif requirement.key?("program")
        "Program is #{requirement['program']}"

      elsif requirement.key?("min-mark")
        "#{requirement['course']}: >= #{requirement['min-mark']}%"
      end
    end
  end
end
