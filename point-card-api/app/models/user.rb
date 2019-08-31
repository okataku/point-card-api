class User < ApplicationRecord

  has_secure_password(validations: false)

  before_create :set_uid, unless: Proc.new {|user| user.uid.present?}
  
  validates :uid, uniqueness: true
  validates :uid, format: { with: ValidationPatterns::ID, allow_nil: true }
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: ValidationPatterns::EMAIL }
  validates :password, presence: true
  validates :password, length: { in: 8..100 }
  validates :gender, inclusion:  { in: %w(male female), allow_nil: true }

  private

  def set_uid
    uid = SecureRandom.alphanumeric
    loop do
      if !self.class.exists?(uid: uid)
        self.uid = uid
        break
      end
    end
  end
end
