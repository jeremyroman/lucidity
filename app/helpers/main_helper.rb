module MainHelper
  def portlet(id, title=nil, &block)
    title ||= id.to_s.titleize
    header = content_tag(:div, title, :class => "portlet-header")
    body = content_tag(:div, capture(&block), :class => "portlet-content")
    concat content_tag(:div, header+body, :id => "portlet-#{id}", :class => "portlet")
  end
end
