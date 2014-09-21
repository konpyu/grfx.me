class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer     :user_id,            null: false
      t.float       :lat
      t.float       :lng
      t.text        :comment
      t.integer     :comment_count,      default: 0
      t.string      :address
      t.string      :status,             default: "published"
      t.string      :key,                null: false

      t.timestamps
    end
  end
end
