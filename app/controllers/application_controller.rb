class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_dashboard_path, :alert => exception.message
  end

  # Override build_footer method in ActiveAdmin::Views::Pages
  require 'active_admin_views_pages_base.rb'

  def authenticate_active_admin_user!
    authenticate_user!
    # unless current_user.superadmin?
    #   flash[:alert] = "Not a superadmin."
    #   #redirect_to root_path
    # end
  end
end
