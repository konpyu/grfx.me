class UserAPI < API
  resource :users do
    params do
      requires :urlname, type: String, regexp: /\A[a-z0-9][a-z0-9_]{2,15}\z/
    end
    get ":urlname", jbuilder: "users/user" do
      @user = User.active.where(urlname: params[:urlname]).first!
    end

    desc 'update user info'
    params do
      optional :profile,     type: String
      optional :website_url, type: String
    end
    put "", jbuilder: "users/update" do
      authenticate!
      @user = User.active.find(current_user.id)

      attrs = params.slice(:profile, :website_url).symbolize_keys
      @user.update!(attrs)
    end

  end
end
