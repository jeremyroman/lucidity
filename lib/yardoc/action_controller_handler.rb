class ActionControllerHandler < YARD::Handlers::Ruby::MethodHandler
  handles :def
  
  def process
    super
    
    return unless namespace.respond_to?(:superclass)
    return unless %w(ApplicationController ActionController::Base).include?(namespace.superclass.to_s)
    return unless namespace.children.last.visibility == :public
    
    # look for an existing tag (we don't want duplicate tags)
    if namespace.docstring.tags.all? { |tag| tag.tag_name != "return" }
      namespace.children.last.docstring.add_tag(YARD::Tags::Tag.new(:return, "", "void"))
    end
  end
end