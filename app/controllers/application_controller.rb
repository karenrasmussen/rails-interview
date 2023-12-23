class ApplicationController < ActionController::Base
  before_action :current_user

  rescue_from ActionController::UnknownFormat, with: :raise_not_found
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  def raise_not_found
    raise ActionController::RoutingError.new('Not supported format')
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
