module API
  class CommentAPI < Grape::API

    resources :comments do
      params do
        requires :id, type: Integer
      end
      delete ':id' do
        authenticate!
        comment = Comment.find(params[:id])
        is_owned_photo = comment.commentable.user_id == current_user.id
        is_my_comment  = comment.user_id == current_user.id
        if is_owned_photo || is_my_comment
          comment.destroy
        else
          error!("Photo Not Found", 404)
        end
        {
          result: true
        }
      end

      params do
        requires :comment, type: String
      end
      put ':id' do
        authenticate!
        comment = current_user.comments.where(id: params[:id]).first!
        comment.comment = params[:comment]
        comment.save!
        present comment, with: Entities::Comment
      end
    end

    params do
      requires :commentables, type: String
    end
    resources ':commentables' do
      params do
        requires :key, type: String
      end
      namespace ':key' do

        resource :comments do
          params do
            requires :comment, type: String
          end
          post '' do
            authenticate!
            commentable_class = params[:commentables].classify
            commentable       = commentable_class.constantize.where(key: params[:key]).first!

            comment = commentable.comments.create
            comment.comment = params[:comment]
            comment.user = current_user
            present comment, with: Entities::Comment
          end
        end
      end
    end
  end
end
