class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_active_admin_user!
    authenticate_user!
    # unless current_user.superadmin?
    #   flash[:alert] = "Not a superadmin."
    #   #redirect_to root_path
    # end
  end
end
