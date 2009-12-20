# Join table between Course and Term.
class CourseMembership < ActiveRecord::Base
  belongs_to :course
  belongs_to :term
end
