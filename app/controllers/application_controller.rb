class ApplicationController < ActionController::Base
  helper ApplicationHelper
  protect_from_forgery
  before_filter :authenticate_user!
end
