module AccessTokenAuth
  extend ActiveSupport::Concern

  def authenticate_user
    begin
      user = current_user
    rescue JWT::ExpiredSignature
      render "errors/expired_access_token", status: :bad_request, format: "json", handler: "jbuilder"
      return false
    rescue JWT::VerificationError
      render "errors/invalid_access_token", status: :bad_request, format: "json", handler: "jbuilder"
      return false
    rescue JWT::DecodeError
      render "errors/invalid_access_token", status: :bad_request, format: "json", handler: "jbuilder"
      return false
    end
      
    if user.nil?
      render "errors/unauthorized", status: :unauthorized, format: "json", handler: "jbuilder"
      return false
    end
  end

  def current_user
    if instance_variable_defined?("@_current_authenticated_user")
      @_current_authenticated_user
    else
      token = access_token
      return if token.nil?
      verify = AccessToken.jwt_decode_varify?
      payload, = decode_access_token(token, verify)
      @_current_authenticated_user = entity_from_payload(payload)
    end
  end

  private

  def entity_from_payload(payload)
    uid = payload.has_key?("uid") ? payload["uid"] : nil
    user = User.find_by(uid: uid)
  end

  def decode_access_token(token, verify = true)
    secret = Rails.application.credentials.secret_key_base
    options = { algorithm: 'HS256' }
    JWT.decode(token, secret, verify, options)
  end

  def access_token
    authorization_header = request.headers["Authorization"]
    return if authorization_header.nil?
    type, token = authorization_header.split
    if  type == "Bearer" && token.present?
      token
    end
  end

end