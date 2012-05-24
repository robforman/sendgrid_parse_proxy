class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_authentication_token

  def load_authentication_token
    @auth_token = ENV.key?('AUTH_TOKEN') ? ENV['AUTH_TOKEN'] : 'f1cbc7bd_DEV_ONLY'
  end

  def ensure_authentication_token
    request_auth_token = request.env['HTTP_X_AUTH_TOKEN']
    request_auth_token ||= params[:auth_token]

    if request_auth_token != @auth_token
      render :text => 'Bad signature.', :status => :forbidden
      return false
    end
  end
end
