class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :redirect_home_if_authenticated
  layout "brochure"

  protected

  def redirect_home_if_authenticated
    if current_user then
      redirect_to dashboard_user_path(current_user)
    end
  end
end
