class AuthenticationController < ApplicationController
  skip_before_action :check_authentication, only: [:login_form, :authenticate]
  skip_before_action :check_setup

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

  def setup
    @status = SetupStatus::Overview.new(current_user)
  end

  def something_awful_identify
    taken_ids = User
      .where(something_awful_verified: true)
      .pluck(:something_awful_id)

    @available_mods = SomethingAwfulUserCache
      .where.not(something_awful_id: taken_ids)
      .order(:name)
  end

  def something_awful_verify
    if current_user.update(params.require(:user).permit(:something_awful_id))
      # trigger profile check
      redirect_to setup_path
    else
      flash.alert(current_user.errors.full_messages.to_sentence)
    end
  end
end
