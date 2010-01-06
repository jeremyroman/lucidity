# AssociationAttributes
module AssociationAttributes
  def association_attributes(*args)
    options = {}
    options.merge!(args.pop) if args.last.is_a? Hash
    
    args.each do |assoc|
      sing = ActiveSupport::Inflector.singularize(assoc.to_s).to_sym
      
      define_method :"new_#{sing}_attributes=" do |attrib_sets|
        attrib_sets.each { |attribs| send(assoc).build(attribs) }
      end
      
      define_method :"existing_#{sing}_attributes=" do |attrib_sets|
        ids = []
        attrib_sets.each do |id, attribs|
          model = send(assoc).find(id)
          model.update_attributes(attribs)
          ids << id
        end
        
        send(assoc).find(:all, :conditions => ["id NOT IN (?)", ids]).each(&:destroy)
      end
    end
  end
end
