# A term in which a user plans to take courses.

class Term < ActiveRecord::Base
  belongs_to :plan
  has_many :course_memberships, :dependent => :destroy
  has_many :courses, :through => :course_memberships
  
  validates_inclusion_of :season, :in => %w(fall winter spring)
  validates_numericality_of :year, :greater_than => 1999, :less_than => 2100
  
  # Human-readable name for the plan
  # @return [String] a name suitable for display to the user
  def name
    "#{season.capitalize} #{year}"
  end
end
