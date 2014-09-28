module API
  module Entities
    # user
    class UserBasic < Grape::Entity
      expose :urlname, :access_token
    end

    class User < UserBasic
      expose :profile, :photo_count, :active_flag, :website_url, :created_at
    end

    # comment
    class CommentBasic < Grape::Entity
      expose :title, :comment, :commentable_id, :commentable_type, :user_id, :role, :created_at
    end

    class Comment < CommentBasic
    end

    # like
    class LikeBasic < Grape::Entity
      expose :votable_id, :votable_type, :voter_id, :voter_type, :created_at
    end

    class Like < LikeBasic
    end

    # photo
    class PhotoBasic < Grape::Entity
      expose :user_id, :lat, :lng, :comment, :comment_count, :address, :status, :key
    end

    # tag
    class Tag < Grape::Entity
      expose :name, :taggings_count
    end

    class Photo < PhotoBasic
      expose :get_likes, as: :likes, using: Entities::Like
      expose :comments, using: Entities::Comment
      expose :tags, using: Entities::Tag
    end

  end
end
