class HomeController < ApplicationController
  def index
    # This will handle both signed-in and guest users
    if user_signed_in? && current_user.admin?
      redirect_to admin_root_path
    end
    # Regular users and guests stay on home page
  end
end
