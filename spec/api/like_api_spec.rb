require 'spec_helper'

describe 'LikeAPI' do
  include ApiHelper
  let(:user) { FactoryGirl.create(:user) }
  let(:creator) { FactoryGirl.create(:user) }
  let(:photo) { FactoryGirl.create(:photo, user: creator) }

  # Liker list
  describe "GET /photo/:key/likes" do
    let(:user_a) { FactoryGirl.create(:user) }
    let(:user_b) { FactoryGirl.create(:user) }
    let(:user_c) { FactoryGirl.create(:user) }
    before do
      user_a.likes(photo)
      user_b.likes(photo)
      user_c.likes(photo)
    end
    it "should return user list which do like" do
      get "/api/photos/#{photo.key}/likes"
      expect(response.status).to eq(200)
      expect(json_response["likes"].length).to eq(3)
    end
  end

  describe "POST /photo/:key/likes" do
    context 'when authorized' do
      it "should create like successfully" do
        post "/api/photos/#{photo.key}/likes", nil,  { 'X-Access-Token' => user.access_token }
        puts json_response
        expect(response.status).to eq(201)
      end
    end
    context 'when not authorized' do
      it "should return auth error" do
        post "/api/photos/#{photo.key}/likes", nil
        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE /likes/:id" do
    context 'when authorized' do
      it "should delete like successfully" do
        delete "/api/photos/#{photo.key}/likes", nil,  { 'X-Access-Token' => user.access_token }
        puts json_response
        expect(response.status).to eq(200)
      end
    end
    context 'when not authorized' do
      it "should return auth error" do
        delete "/api/photos/#{photo.key}/likes", nil
        expect(response.status).to eq(401)
      end
    end
  end

end
