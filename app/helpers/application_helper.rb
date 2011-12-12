module ApplicationHelper
  def red(text)
    RedCloth.new(text).to_html.html_safe
  end
end
