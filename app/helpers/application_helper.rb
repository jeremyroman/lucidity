# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def adaptive_fields_for(prefix, model, &block)
    kind = model.new_record? ? "new" : "existing"
    model_kind = ActiveSupport::Inflector.underscore(model.class)
    fields_for("#{prefix}[#{kind}_#{model_kind}_attributes][]", model, &block)
  end
end
