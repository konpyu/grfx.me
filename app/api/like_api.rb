module API
  class LikeAPI < Grape::API
    params do
      requires :likables, type: String
    end
    resources ':likables' do
      params do
        requires :key, type: String
      end
      namespace ':key' do
        resource :likes do
          get '' do
            likable_class = params[:likables].classify
            likable = likable_class.constantize.where(key: params[:key]).first!
            present likable.get_likes, with: Entities::Like
          end

          post '' do
            authenticate!
            likable_class = params[:likables].classify
            likable = likable_class.constantize.where(key: params[:key]).first!
            result = current_user.likes(likable)
            {
              result: result
            }
          end

          delete '' do
            authenticate!
            likable_class = params[:likables].classify
            likable = likable_class.constantize.where(key: params[:key]).first!
            result = current_user.dislikes(likable)
            {
              result: result
            }
          end
        end
      end
    end
  end
end
