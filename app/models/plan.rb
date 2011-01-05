# Represents a possible planned course sequence for a user.

class Plan < ActiveRecord::Base
  belongs_to :user
  has_many :terms, :dependent => :destroy
  
  validates_presence_of :name
  accepts_nested_attributes_for :terms, :allow_destroy => true
  validates_associated :terms, :message => "are invalid"
  
  # Construct default terms from a number of terms
  # and start year given in a hash.
  # 
  # @example Mass-assign <tt>term_spawn</tt>
  #  Plan.new(:term_spawn => {:num_terms => 11, :first_year => 2009})
  #
  # Either or both of the keys may be omitted, in which case 11 terms
  # (a standard four-year honours baccalaureate) and the current year
  # are assumed to be the default.
  #
  # @example Mass-assign <tt>term_spawn</tt> with default settings
  #  Plan.new(:term_spawn => {})
  #
  # This attribute should not be set multiple times.
  #
  # @return [void]
  def term_spawn=(data)
    num_terms = data[:num_terms].to_i || 11
    first_year = data[:first_year].to_i || Date.today.year
    
    num_terms.times do |n|
      season = %w(fall winter spring)[n%3]
      year = first_year + (n+2)/3
      terms.build(:season => season, :year => year)
    end
  end
  
  # Creates another Plan with the same terms and course sequence.
  #
  # @raise [ActiveRecord::RecordNotSaved]
  # @return (Plan) new plan
  def duplicate
    new_plan = clone
    new_plan.terms = terms.map do |t|
      new_term = t.clone
      new_term.course_memberships = t.course_memberships.map(&:clone)
      new_term
    end
    new_plan.save!
    new_plan
  end
  
  def conflicts
    t1 = Time.now
    result = []
    rc = RequirementChecker.new(self)
    Rails.logger.debug("\033[43m\033[1mRequirementChecker.new: #{Time.now-t1} seconds\033[0m")
    
    terms.find(:all, :include => :course_memberships).each do |term|
      rc.term = term
      
      term.course_memberships.find(:all, :include => :course).each do |cm|
        t1 = Time.now
        rc.course = cm.course
        unless cm.override
          result += rc.check.map do |conflict|
            { :course_id => cm.course_id, :term_id => cm.term_id, :message => conflict.message }
          end
        end
        Rails.logger.debug("\033[43m\033[1m#{cm.course.code}: #{Time.now-t1} seconds\033[0m")
      end
    end
    
    result
  end
end
