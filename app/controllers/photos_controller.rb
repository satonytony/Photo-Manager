class PhotosController < ApplicationController
  before_action :require_login

  def index
    @photos = []
  end
end
