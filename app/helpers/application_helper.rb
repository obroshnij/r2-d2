module ApplicationHelper

  def full_title(page_title = '')
    base_title = "R2-D2"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def selected?(str, title)
  	str == title.to_s ? "active" : ""
  end
  
  def link_to_add_virtus_fields(name, f, association, object, partial)
    new_object = object.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) { |f| render(partial, f: f) }
    link_to(name, '#', class: "add-virtus-fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

end