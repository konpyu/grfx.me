class Photo < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :tags
  belongs_to :user
end
