class Term < ActiveRecord::Base
  has_many :course_memberships
  has_many :courses, :through => :course_memberships
  
  def <<(obj)
    if obj.is_a? String
      self << Course.find_by_code(obj)
    elsif obj.is_a? Fixnum
      self << Course.find(obj)
    else
      self.courses << obj
    end
  end
end
