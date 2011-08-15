class Admin::Controller < ActionController::Base
  layout "administration"
  
  before_filter :verify_admin

  protected
  
  def verify_admin
    authenticate_user!
    redirect_to root_path unless current_user.admin?
  end
end
