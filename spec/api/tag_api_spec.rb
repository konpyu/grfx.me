require 'spec_helper'

describe 'TagAPI' do
  include ApiHelper

  let(:user) { FactoryGirl.create(:user) }

  describe 'GET /tags/:tagname' do

    before do
      3.times do
        photo = FactoryGirl.create(:photo, user: user)
        photo.tag_list.add("graffiti")
        photo.save!
      end
    end

    it 'should return tagged photos when call for exists tag' do
      get "/api/tags/graffiti"
      expect(response.status).to eq(200)
      expect(json_response['photo_count']).to eq(3)
    end

    it 'should return nothing when call for not exists tag' do
      get "/api/tags/non_exist_tag"
      expect(response.status).to eq(200)
      expect(json_response['photo_count']).to eq(0)
    end
  end
end
