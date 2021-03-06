Dir["#{Rails.root}/app/api/*.rb"].each {|file| require file}
module API
  class API < Grape::API
    format    :json

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error_response(message: "Validation Error", status: 400)
    end
    rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError do |e|
      error_response(message: "Resource Not Found", status: 404)
    end
    rescue_from :all do |e|
      if Rails.env.development?
        raise e
      else
        error_response(message: "Internal Server Error", status: 500)
        # TODO: logging
      end
    end

    # Auth Check
    before do
      # Do you have access token?
      if !request.get?
        # return 401
      end
    end

    helpers do
      def current_user
        @current_user ||= User.active.find_by(access_token: headers["X-Access-Token"])
        return nil unless @current_user
        @current_user
      end
      def authenticate!
        error!('Invalid Access Token', 401) unless current_user
      end
    end

    mount UserAPI
    mount TagAPI
    mount PhotoAPI
    mount CommentAPI
    mount LikeAPI
    mount SessionAPI
  end
end
