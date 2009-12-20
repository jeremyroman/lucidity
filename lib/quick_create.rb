# Tool intended for use in script/console for manually
# adding courses without issuing ActiveRecord or SQL
# commands.
module QuickCreate
  VERSION = 1.1
  
  # Runs the QuickCreate wizard.
  def self.run
    puts "=== Course QuickCreate ==="
    attribs = {}
    
    for input in (inputs = %w(code name offered))
      printf "%s: ", input.capitalize.rjust(inputs.map(&:size).max)
      attribs[input.to_sym] = gets.strip
    end
    
    c = Course.new(attribs)
    
    puts "Course Requirements:"
    loop do
      print "  Number: "
      num = gets.to_i
      break if num.zero?
      print "  Prerequisites: "
      cg = CourseGroup.create
      cg.courses << Course.find_all_by_code(gets.strip.split(/ *, */))
      cg.save!
      
      c.course_requirements.build(:number => num, :course_group => cg)
      puts ""
    end
    
    c.save!
    c
  end

end