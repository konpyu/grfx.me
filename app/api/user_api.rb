module API
  class UserAPI < Grape::API
    resource :users do
      params do
        requires :urlname, type: String, regexp: /\A[a-z0-9][a-z0-9_]{2,15}\z/
      end
      get ":urlname" do
        @user = User.active.where(urlname: params[:urlname]).first!
        present @user, with: Entities::User
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
