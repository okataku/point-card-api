class Auth::SigninController < ApplicationController
  def index
    render plain: 'This is Auth Singin'
  end

  def create
    credential = auth_params
    user = User.find_by(email: credential[:email])

    if !user
      render "errors/bad_credentials",
        status: :unauthorized, format: "json", handlers: "jbuilder"
      return
    end

    if !user.authenticate(credential[:password])
      render "errors/bad_credentials", status: :unauthorized
      return
    end

    @access_token = AccessToken.issue(user)
    @access_token.save

    payload = {
      jti: @access_token.id,
      exp: @access_token.expire_time,
      iat: @access_token.issued_at,
      uid: user.uid
    }
    secret = Rails.application.credentials.secret_key_base
    jwt = JWT.encode(payload, secret, 'HS256')
    @access_token.access_token = jwt
    @access_token.save
    
    render "auth/access_token", status: :ok
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
