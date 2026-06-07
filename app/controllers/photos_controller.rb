class PhotosController < ApplicationController
  include MyTweetApiClient
  before_action :require_login

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
    # TODO: ツイート失敗時（false/nil）はユーザーにエラーを通知する
    post_tweet(session[:access_token], @photo.title, image_url)
    redirect_to photos_path
  end

  private

  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
