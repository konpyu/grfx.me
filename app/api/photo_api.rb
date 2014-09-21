class PhotoAPI < API
  resource :photos do
    namespace ':key' do
      before do
        @photo = Photo.find_by(key: params[:key])
      end
      get '' do
        {
          photo: @photo
        }
      end

      params do
        requires :tags,     type: Array
      end
      post 'tags' do
        authenticate!
        @photo.tag_list.add(params[:tags])
        @photo.save!
        {
          result: true
        }
      end

      params do
        optional :lat,      type: Float
        optional :lng,      type: Float
        optional :comment,  type: String
        optional :address,  type: String
      end
      put '' do
        authenticate!
        attrs = params.slice(:lat, :lng, :comment, :address).symbolize_keys
        @photo.update(attrs)
        {
          photo: @photo
        }
      end

      delete '' do
        authenticate!
        @photo.destroy
        {
          photo: @photo
        }
      end

      params do
        requires :tagname, type: String
      end
      delete 'tags/:tagname' do
        authenticate!
        @photo.tag_list.remove(params[:tagname])
        @photo.save!
        {
          result: true
        }
      end
    end

    params do
      optional :lat,      type: Float
      optional :lng,      type: Float
      optional :comment,  type: String
      optional :address,  type: String
    end
    post '' do
      authenticate!
      result = current_user.photos.create!(
        lat:     params[:lat],
        lng:     params[:lng],
        comment: params[:comment],
        address: params[:address],
      )
      {
        photo: result
      }
    end
  end
end
