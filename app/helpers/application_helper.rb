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

  def game_text(game, prefix)
    prefix + (game.pgn.blank? ? "" : " (PGN)")
  end

  def date_only_datetime_text(datetime)
    if datetime
      datetime.localtime.strftime("%m/%d/%Y")
    else
      ""
    end
  end

  def full_datetime_text(datetime)
    if datetime
      datetime.localtime.strftime("%m/%d/%Y %I:%M%p")
    else
      ""
    end
  end

  def player_name(player)
    if player.league
      player.name
    else
      "#{player.name} (OUT)"
    end
  end

  def image_url(source, request)
    rel_path = image_path(source)
    abs_prefix = "#{request.protocol}#{request.host}"
    abs_prefix << ":#{request.port}" if request.port != 80
    "#{abs_prefix}/#{rel_path}"
  end 
end

