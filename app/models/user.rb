class User < ActiveRecord::Base
  scope :active, -> { where(active_flag: true) }
  before_save :ensure_access_token

  def ensure_access_token
    if self.access_token.blank?
      self.access_token = generate_access_token
    end
  end

  private
  def generate_access_token
    'u' + SecureRandom.hex(16)
  end

end
