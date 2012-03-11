class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_dashboard_path, :alert => exception.message
  end

  def authenticate_active_admin_user!
    authenticate_user!
    # unless current_user.superadmin?
    #   flash[:alert] = "Not a superadmin."
    #   #redirect_to root_path
    # end
  end
end
