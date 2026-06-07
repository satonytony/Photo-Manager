class OauthController < ApplicationController
  before_action :require_login

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
    # 要件6で実装
  end
end
