class MUser < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  attr_accessor :auth_token
  def MUser.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end


  def create_auth_digest
    self.auth_token = MUser.new_token
    update_attribute(:auth_digest,  MUser.digest(auth_token))
    update_attribute(:auth_sent_at, Time.zone.now)
  end

  def MUser.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns true if the given token matches the digest.
  def authenticated?(token)
    BCrypt::Password.new(auth_digest).is_password?(token)
  end

  def auth_token_expired?
    auth_sent_at < 30.minutes.ago
  end

  # Forgets a user.
  def forget
    update_attribute(:auth_digest, nil)
  end

end
