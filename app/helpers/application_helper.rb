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

end
