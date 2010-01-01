# Represents a single term within a plan.
class Term < ActiveRecord::Base
  has_many :course_memberships, :dependent => :destroy, :order => "position"
  has_many :courses, :through => :course_memberships
  belongs_to :plan
  
  # Key used to store the view fragment
  # (centralized to avoid errors in duplication)
  def cache_key
    "terms/#{id}"
  end
  
  #:nocov:
  
  # Adds a course to the term, looking it up in the database
  # if necessary. Useful shorthand for script/console.
  def <<(obj)
    if obj.is_a? String
      self << Course.find_by_code(obj)
    elsif obj.is_a? Fixnum
      self << Course.find(obj)
    else
      self.courses << obj
    end
  end
  
  #:nocov:
end
