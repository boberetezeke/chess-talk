module ApplicationHelper

  def formatted_rating(rating)
    "%.1f" % rating
  end

  def set_active_tab(controller, action)
logger.debug "controller, action = #{controller},#{action} -- #{params[:controller]}, #{params[:action]}"
    (params[:controller] == controller && params[:action] == action) ?
      "active" : "inactive"
  end

  def tab_link_to(text, path, options={})
    link_to text, path, options.merge(current_page?(path) ? {:class => "active"} : {})
  end

  def header_link_to(text, path, options={})
    "<span>(" + link_to(text, path, options) + ")</span>"
    a = link_to(text, path, options)
    b = "<a href=\"#{path}\">#{text}</a>"

    logger.debug "header_link_to: a=#{a.inspect}, b=#{b.inspect} a==b=#{(a==b).inspect}"
    return a
  end
end
