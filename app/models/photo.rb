class Photo < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :tags
  belongs_to :user

  before_save :ensure_key
  def ensure_key
    if self.key.blank?
      self.key = 'p' + SecureRandom.hex(16)[0..11]
    end
  end
end
