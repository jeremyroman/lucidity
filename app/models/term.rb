# Represents a single term within a plan.
class Term < ActiveRecord::Base
  has_many :course_memberships, :dependent => :destroy
  has_many :courses, :through => :course_memberships
  
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
