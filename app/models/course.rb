# Represents a course which may be taken by students.

class Course < ActiveRecord::Base
  belongs_to :catalogue
  has_many :course_memberships, :dependent => :destroy
  has_many :terms, :through => :course_memberships
  
  default_scope order(:code)
  
  validates_presence_of :code, :name, :offered, :description
  validates_format_of :code, :with => /^[A-Z]+ \d+[A-Z]?$/
  validates_format_of :offered, :with => /^F?W?S?$/
  
  # Modifies the URL param for nicer URLs
  # @return (String) parsable URL parameter
  def to_param
    "#{id}-#{code.gsub(/ /,"-")}"
  end
  
  # Returns the (deserialized) requirements
  def requirements_data
    JSON.parse(requirements) rescue []
  end
  
  # Sets (and serializes) requirements
  def requirements_data=(new_requirements)
    requirements = new_requirements.to_json
  end
end
