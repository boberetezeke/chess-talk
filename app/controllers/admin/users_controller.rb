class Admin::UsersController < Admin::Controller
  layout "administration"
  inherit_resources

  def dashboard
    @page_title = "Admin Dashboard"
    @users = User.all
    @leagues = League.all
  end
end
