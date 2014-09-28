Rails.application.routes.draw do
  mount API::API, at: '/api'
end
