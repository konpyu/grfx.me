module API
  class SessionAPI < Grape::API
    namespace ":session" do

      params do
        requires :urlname,   type: String
      end
      post "login" do
        # password skip temporary
        user = User.find_by(urlname: params[:urlname])
        user.regenerate_access_token
        user.save!
        present user, Entities::User
      end

      post "logout" do
        authenticate!
        current_user.delete_access_token
        current_user.save!
        { result: true }
      end

      params do
        requires :urlname,   type: String
      end
      post "signup" do
        user = User.find_by(urlname: params[:urlname])
        error!("user already exists", 401) if user.present?

        user = User.create!(
          urlname: params[:urlname],
          active_flag: true,
        )
        present user, Entities::User
      end

    end
  end
end
