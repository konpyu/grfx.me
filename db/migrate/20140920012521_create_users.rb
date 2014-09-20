class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string      :urlname
      t.string      :profile
      t.boolean     :active_flag,     default: true
      t.integer     :photo_count,     default: 0
      t.integer     :following_count, default: 0
      t.integer     :follower_count,  default: 0
      t.integer     :like_count,      default: 0
      t.string      :access_token
      t.string      :website_url
      t.timestamps
    end
  end
end
