# Represents a course catalog.
# For example, different academic years may have separate catalogues.

class Catalogue < ActiveRecord::Base
  has_many :courses
end
