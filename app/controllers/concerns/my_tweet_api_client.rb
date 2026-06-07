require "net/http"

module MyTweetApiClient
  extend ActiveSupport::Concern

  def fetch_access_token(code)
    with_http_rescue do
      uri = URI.parse(MY_TWEET[:token_url])
      res = Net::HTTP.post_form(uri, {
        grant_type:    "authorization_code",
        code:          code,
        client_id:     MY_TWEET[:client_id],
        client_secret: MY_TWEET[:client_secret],
        redirect_uri:  MY_TWEET[:redirect_uri]
      })
      JSON.parse(res.body)["access_token"] if res.is_a?(Net::HTTPSuccess)
    end
  end

  private

  def with_http_rescue
    yield
  rescue StandardError
    # TODO: エラー種別に応じたログ記録・ユーザ通知等を整備する
    nil
  end
end
