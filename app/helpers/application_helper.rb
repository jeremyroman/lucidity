module ApplicationHelper
  # Gets and/or sets the page title
  #
  # @param (String) new_title  If set, the page title is changed to this value
  # @return (String) page title
  def title(new_title = nil)
    @title = new_title || @title
  end
end
