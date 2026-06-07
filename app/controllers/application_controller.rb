class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :require_login

  rescue_from MyTweetApiClient::Error, with: :handle_my_tweet_api_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  helper_method :current_user, :logged_in?

  private

  def handle_my_tweet_api_error
    # TODO: 通信エラーが起きたことをユーザーに伝える必要がある
    redirect_to photos_path
  end

  def handle_record_not_found
    # TODO: 対象が見つからなかったことをユーザーに伝える必要がある
    redirect_to photos_path
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    # TODO: 未ログイン時にリダイレクトする際、ログインが必要であることをユーザーに伝える
    redirect_to login_path unless logged_in?
  end
end
