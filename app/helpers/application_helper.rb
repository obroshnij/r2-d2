module ApplicationHelper

  def full_title(page_title = '')
    base_title = "R2-D2"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def selected?(str, title)
  	str == title.to_s ? "active" : ""
  end

end
