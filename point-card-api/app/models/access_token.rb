class AccessToken < ApplicationRecord

  before_create :set_id
  before_create :set_refresh_token

  EXPIRES_IN = 3600 / 2
  REFRESH_TOKEN_EXPIRES_IN = 30 * 24 * 3600

  def self.issue(user,
    issued_at = Time.now,
    expires_in = EXPIRES_IN,
    refresh_token_expires_in = REFRESH_TOKEN_EXPIRES_IN)

    self.new(
      #id: SecureRandom.uuid,
      user_id: user.id,
      access_token: "",
      issued_at: issued_at,
      expires_in: expires_in,
      expire_time: issued_at + expires_in,
      #refresh_token: SecureRandom.uuid,
      refresh_token_expires_in: refresh_token_expires_in,
      refresh_token_expire_time: issued_at + refresh_token_expires_in,
      refresh_count: 0)
  end

  def self.jwt_decode_varify?
    !(Rails.env.development? && "off".casecmp(ENV["JWT_DECODE_VARIFY"]))
  end

  private

  def set_id
    self.id = uuid(:id)
  end

  def set_refresh_token
    self.refresh_token = uuid(:refresh_token)
  end

  def uuid(column)
    loop do
      uuid = SecureRandom.uuid
      break uuid unless self.class.exists?({ column => uuid })
    end
  end

end
