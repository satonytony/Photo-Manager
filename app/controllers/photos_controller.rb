class PhotosController < ApplicationController
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

  private

  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
