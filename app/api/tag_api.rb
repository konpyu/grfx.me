class TagAPI < API
  resource :tags do
    params do
      requires :tagname, type: String
    end
    get ":tagname" do
      @photos = Photo.tagged_with(params[:tagname])
      {
        photo_count: @photos.length,
        photos: @photos
      }
    end
  end
end
