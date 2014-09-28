class User < ActiveRecord::Base
  acts_as_tagger
  acts_as_voter

  scope :active, -> { where(active_flag: true) }
  before_save :ensure_access_token
  has_many :photos
  has_many :comments

  validates :urlname, presence: true, length: { within: 3..20 }

  def ensure_access_token
    if self.access_token.blank?
      self.access_token = generate_access_token
    end
  end

  def regenerate_access_token
    self.access_token = generate_access_token
  end

  def delete_access_token
    self.access_token = nil
  end

  private
  def generate_access_token
    'u' + SecureRandom.hex(16)
  end

end
