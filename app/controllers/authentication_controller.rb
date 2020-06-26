class AuthenticationController < ApplicationController
  skip_before_action :check_authentication, only: [:login_form, :authenticate]

  def login_form; end

  def authenticate
    if (user = User.find_by(email: params[:email]))
      if user.authenticate(params[:password])
        cookies.encrypted[:user_id] = session[:user_id] = user.id
      else
        flash.alert("Login failed.")
      end
    end

    redirect_to root_path
  end

  def logout
    session.delete(:user_id)

    redirect_to login_path
  end
end
