require 'active_support/inflector'

class ActiveRecordHandler < YARD::Handlers::Ruby::Base
  handles method_call(:belongs_to)
  handles method_call(:has_many)
  handles method_call(:has_many_and_belongs_to)
  namespace_only
  
  def process
    relation_type = statement.method_name(true)
    name = statement.parameters.first.jump(:tstring_content, :ident).source
    class_name = ActiveSupport::Inflector.classify(name)
    
    # look for an explicitly specified :class_name parameter
    args = statement.parameters.jump(:assoc)
    if args != statement.parameters
      args.parent.select { |a| a.type == :assoc}.each do |assoc|
        key = assoc.jump(:ident).source
        value = assoc[1].jump(:ident, :tstring_content).source
        class_name = value if key == 'class_name'
      end
    end
    
    # look for an existing tag (we don't want duplicate tags)
    namespace.docstring.tags.each do |tag|
      return if tag.tag_name == relation_type.to_s && tag.name == name
    end
    
    tag = YARD::Tags::Tag.new(relation_type, "", class_name, name)
    namespace.docstring.add_tag(tag)
  end
end