class HomeController < ApplicationController
  def index
    # This will handle both signed-in and guest users
    if user_signed_in?
      if current_user.admin?
        redirect_to admin_root_path
      else
        redirect_to events_path
      end
    end
    # Only guests (non-signed-in users) stay on home page
  end
end
