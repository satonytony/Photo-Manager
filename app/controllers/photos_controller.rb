class PhotosController < ApplicationController
  def index
    @photos = current_user.photos.order(created_at: :desc)
  end

  def new
  end

  def create
    @photo = current_user.photos.build(photo_params)
    if @photo.save
      redirect_to photos_path
    else
      render :new, status: :unprocessable_content
    end
  end

  def tweet
    @photo = current_user.photos.find(params[:id])
    image_url = rails_blob_url(@photo.image, host: request.base_url)
    api_client.post_tweet(session[:access_token], @photo.title, image_url)
  rescue MyTweetApiClient::Error
    # TODO: 素のエラーをそのまま出さないよう、ユーザー向けの適切なエラー表示に変換する必要がある
  ensure
    redirect_to photos_path
  end

  private

  def api_client
    MyTweetApiClient.new
  end

  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
