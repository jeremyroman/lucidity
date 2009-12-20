# extenstion to ActiveRecord which allows notation like Plan[3]
# instead of Plan.find(3). Sometimes nice in script/console,
# and doesn't seem to conflict with anything else.

#
class ActiveRecord::Base
  # extenstion to ActiveRecord which allows notation like Plan[3]
  # instead of Plan.find(3). Sometimes nice in script/console,
  # and doesn't seem to conflict with anything else.
  def self.[](index); self.find(index); end
end