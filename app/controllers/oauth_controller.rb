class OauthController < ApplicationController
  def authorize
    query = {
      response_type: "code",
      client_id:     MY_TWEET[:client_id],
      redirect_uri:  MY_TWEET[:redirect_uri],
      scope:         MY_TWEET[:scope]
    }.to_query
    redirect_to "#{MY_TWEET[:authorize_url]}?#{query}", allow_other_host: true
  end

  def callback
    code = params[:code]
    if code.present?
      token = api_client.fetch_access_token(code)
      session[:access_token] = token if token
    end
    redirect_to photos_path
  end

  private

  def api_client
    MyTweetApiClient.new
  end
end
