class PhotosController < ApplicationController
  before_action :require_login

  def index
    @photos = []
  end

  def new
  end

  def create
  end
end
