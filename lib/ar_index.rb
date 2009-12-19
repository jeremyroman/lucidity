class ActiveRecord::Base
  def self.[](index); self.find(index); end
end