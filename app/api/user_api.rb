module API
  class UserAPI < Grape::API
    resource :users do
      params do
        requires :urlname, type: String, regexp: /\A[a-z0-9][a-z0-9_]{2,15}\z/
      end

      namespace ':urlname' do
        before do
          @user = User.active.where(urlname: params[:urlname]).first!
        end
        get '' do
          present @user, with: Entities::User
        end

        params do
          optional :count,   type: Integer
        end
        get 'photos' do
          count = params[:count] || 12
          photos = @user.photos
                        .order(created_at: :desc)
                        .limit(count)
          present photos, with: Entities::Photo
        end
      end

      params do
        optional :profile,     type: String
        optional :website_url, type: String
      end
      put "" do
        authenticate!
        @user = User.active.find(current_user.id)

        attrs = params.slice(:profile, :website_url).symbolize_keys
        @user.update!(attrs)
        present @user, with: Entities::User
      end
    end
  end
end
