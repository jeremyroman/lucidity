# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def adaptive_fields_for(prefix, model, &block)
    kind = model.new_record? ? "new" : "existing"
    model_kind = ActiveSupport::Inflector.underscore(model.class)
    fields_for("#{prefix}[#{kind}_#{model_kind}_attributes][]", model, &block)
  end
  
  def show_flash
    flash.map do |key, message|
      content_tag(:p, message, :class => "flash flash-#{key}")
    end.join
  end
  
  def sentence_with_links(array, display_method)
    array.map { |model| link_to(model.send(display_method), model) }.to_sentence
  end
  
  def page_title(new_title = nil)
    if new_title.nil?
      @page_title
    else
      @page_title = new_title
    end
  end
end
