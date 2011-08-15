class ApplicationController < ActionController::Base
  inherit_resources
  helper ApplicationHelper
  protect_from_forgery
  before_filter :authenticate_user!
end
