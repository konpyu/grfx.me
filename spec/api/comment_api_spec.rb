require 'spec_helper'

describe 'CommentAPI' do
  include ApiHelper
  let(:user) { FactoryGirl.create(:user) }

  describe "POST /photo/:key/comments" do
    let(:photo) { FactoryGirl.create(:photo, user: user) }
    let(:new_comment) {
      {
        comment: "I like your photo"
      }
    }
    context 'when authorized' do
      it 'should return updated user' do
        post "/api/photos/#{photo.key}/comments", new_comment, { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(201)
        expect(json_response["comment"]["comment"]).to eq("I like your photo")
        expect(json_response["comment"]["user_id"]).to eq(user.id)
      end
    end
    context 'when not authorized' do
      it 'should return auth error' do
        post "/api/photos/#{photo.key}/comments", new_comment
        expect(response.status).to eq(401)
      end
    end
  end

  describe "PUT /comments/:id" do
    let!(:photo) { FactoryGirl.create(:photo, user: user) }
    let!(:other) { FactoryGirl.create(:user) }
    let!(:comment) { FactoryGirl.create(:comment, user: user, commentable: photo) }
    let!(:others_comment) { FactoryGirl.create(:comment, user: other, commentable: photo) }
    context 'when authorized' do
      it 'should update successfully when try to update owned comment' do
        put "/api/comments/#{comment.id}", { comment: "super schooter happy" } , { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(200)
        expect(json_response["comment"]["comment"]).to eq("super schooter happy")
      end
      it 'should return error when try to update others comments' do
        put "/api/comments/#{others_comment.id}", { comment: "super schooter happy" } , { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(404)
      end
    end
    context 'when not authorized' do
      it 'should return auth error' do
        put "/api/comments/#{comment.id}", { comment: "super schooter happy" }
        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE /comments/:id" do
    let!(:photo) { FactoryGirl.create(:photo, user: user) }
    let!(:other) { FactoryGirl.create(:user) }
    let!(:comment) { FactoryGirl.create(:comment, user: user, commentable: photo) }
    let!(:others_comment) { FactoryGirl.create(:comment, user: other, commentable: photo) }
    let!(:others_photo)   { FactoryGirl.create(:photo, user: other) }
    let!(:others_photo_comment) { FactoryGirl.create(:comment, user: other, commentable: others_photo) }
    context 'when authorized' do
      # 自分のコメントは消せる
      it 'should delete successfully when try to delete owned comment' do
        delete "/api/comments/#{comment.id}", nil, { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(200)
      end
      # 自分の写真のコメントは消せる
      it 'should delete successfully when try to comment related to owned photo' do
        delete "/api/comments/#{others_comment.id}", nil, { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(200)
      end
      # 他人のコメントは消せない
      it 'should return error when try to delete others comments' do
        delete "/api/comments/#{others_photo_comment.id}", nil, { 'X-Access-Token' => user.access_token }
        expect(response.status).to eq(404)
      end
    end
    context 'when not authorized' do
      it 'should return auth error' do
        delete "/api/comments/#{comment.id}", nil
        expect(response.status).to eq(401)
      end
    end
  end
end
