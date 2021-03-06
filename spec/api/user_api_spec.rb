require 'spec_helper'

describe 'UserAPI' do
  include ApiHelper

  let(:user) { FactoryGirl.create(:user) }

  describe 'GET /users/:urlname/photos' do
    before do
      12.times do
        FactoryGirl.create(:photo, user: user)
      end
    end

    it 'should return 12 photos by default' do
      get "/api/users/#{user.urlname}/photos"
      expect(response.status).to eq(200)
      expect(json_response.length).to eq(12)
    end

    it 'should return count option number of photo' do
      get "/api/users/#{user.urlname}/photos?count=10"
      expect(response.status).to eq(200)
      expect(json_response.length).to eq(10)
    end
  end

  describe 'GET /users/:urlname' do
    it 'should return user' do
      get "/api/users/#{user.urlname}"
      expect(response.status).to eq(200)
      expect(json_response["urlname"]).to eq(user.urlname)
    end
  end

  describe 'PUT /users' do
    context 'when authorized' do
      it 'should return updated user' do
        put "/api/users", { profile: "from NYC", website_url: "http://tokyotownname.com"}, { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(200)
        expect(json_response["profile"]).to eq("from NYC")
        expect(json_response["website_url"]).to eq("http://tokyotownname.com")
      end
    end
    context 'when not authorized' do
      it 'should return auth error' do
        put "/api/users", { profile: "from NYC" }
        expect(response.status).to eq(401)
      end
    end
  end

end
