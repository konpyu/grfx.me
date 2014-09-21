require 'spec_helper'

describe 'PhotoAPI' do
  include ApiHelper

  let(:user) { FactoryGirl.create(:user) }

  describe 'GET /photos/:key' do
    let(:photo) { FactoryGirl.create(:photo, user: user) }
    it 'should return photo' do
      get "/api/photos/#{photo.key}"
      expect(response.status).to eq(200)
    end
  end

  describe 'POST /photos' do
    let(:new_photo_param) {
      {
        lat: 35.65858,
        lng: 139.745433,
        address: '東京都港区芝公園4-2-8',
        comment: 'TOKIO TOWER!',
      }
    }
    context 'when authorized' do
      it 'should return created photo' do
        post '/api/photos', new_photo_param, { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(201)
      end
    end
    context 'when not authorized' do
      it 'should return auth error' do
        post '/api/photos', new_photo_param
        expect(response.status).to eq(401)
      end
    end
  end

  # 個別にタグを追加する時
  describe 'POST /photos/:key/tags' do
    let(:photo) { FactoryGirl.create(:photo, user: user) }
    let(:new_tag_param) {
      {
        tags: ["cool", "hot", "sexy"]
      }
    }
    context 'when authorized' do
      it 'should return tags' do
        post "/api/photos/#{photo.key}/tags", new_tag_param, { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(201)
        photo.reload
        expect(photo.tag_list).to eq(["cool", "hot", "sexy"])
      end
    end
    context 'when not authorized' do
      it 'should return auth error' do
        post "/api/photos/#{photo.key}/tags", new_tag_param
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'PUT /photos/:key' do
    let(:photo) { FactoryGirl.create(:photo, user: user) }
    let(:update_photo_param) {
      {
        lat: 45.0625,
        lng: 141.353611,
        address: '札幌市中央区北1条西2-1-1',
        comment: 'SAPPORO TOKEIDAI',
      }
    }
    context 'when authorized' do
      it 'should return updated photo' do
        put "/api/photos/#{photo.key}", update_photo_param, { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(200)
        expect(json_response["photo"]["lat"]).to eq(45.0625)
        expect(json_response["photo"]["lng"]).to eq(141.353611)
        expect(json_response["photo"]["address"]).to eq('札幌市中央区北1条西2-1-1')
        expect(json_response["photo"]["comment"]).to eq('SAPPORO TOKEIDAI')
      end
    end
    context 'when not authorized' do
      it 'should return auth error' do
        put "/api/photos/#{photo.key}", update_photo_param
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE /photos/:key' do
    let(:photo) { FactoryGirl.create(:photo, user: user) }
    context 'when authorized' do
      it 'should delete photo successfully' do
        delete "/api/photos/#{photo.key}", nil, { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(200)
      end
    end
    context 'when not authorized' do
      it 'should return auth error' do
        delete "/api/photos/#{photo.key}"
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE /photos/:key/tags/:tagname' do
    let(:photo) { FactoryGirl.create(:photo, user: user) }
    before do
      photo.tag_list.add("hot")
      photo.save!
    end
    context 'when authorized' do
      it 'should delete tag successfully' do
        delete "/api/photos/#{photo.key}/tags/hot", nil , { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(200)
        photo.reload
        expect(photo.tag_list).to eq([])
      end
    end
    context 'when not authorized' do
      it 'should return auth error' do
        delete "/api/photos/#{photo.key}/tags/hot"
        expect(response.status).to eq(401)
      end
    end
  end

end
