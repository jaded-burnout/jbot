class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :check_authentication
  before_action :check_setup

  default_form_builder GenericFormBuilder

private

  def check_authentication
    redirect_to login_path unless logged_in?
  end

  def check_setup
    redirect_to setup_path unless setup_finished?
  end

  def setup_finished?
    SetupStatus::Overview.new(current_user).finished?
  end
  helper_method :setup_finished?

  def logged_in?
    current_user.present?
  end
  helper_method :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user
end
