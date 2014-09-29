require 'spec_helper'

describe 'SessionAPI' do
  include ApiHelper

  describe 'POST /sessions/signup' do

    it 'should create user' do
      post '/api/sessions/signup', { urlname: 'konpyu' }
      expect(response.status).to eq(201)
      expect(json_response["urlname"]).to eq("konpyu")
      expect(json_response["access_token"]).to match(/u[0-9a-z]{32}/)
    end

    it 'should return error' do
      # TODO: within context
      FactoryGirl.create(:user, urlname: 'konpyu')
      post '/api/sessions/signup', { urlname: 'konpyu' }
      expect(response.status).to eq(401)
    end

  end

  describe 'POST /sessions/login' do
    it 'should login successfully' do
      user = FactoryGirl.create(:user, urlname: 'konpyu')
      before_access_token = user.access_token
      post '/api/sessions/login', { urlname: 'konpyu', password: 'hogehoge' }
      expect(response.status).to eq(201)
      expect(json_response["urlname"]).to eq("konpyu")
      expect(json_response["access_token"]).to match(/u[0-9a-z]{32}/)
      expect(json_response["access_token"]).not_to eq(before_access_token)
    end
  end

  describe 'POST /sessions/logout' do
    pending "logout --------------------------------"
  end

end
