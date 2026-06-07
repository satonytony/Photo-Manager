require "net/http"

class MyTweetApiClient
  class Error < StandardError; end

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

  def post_tweet(access_token, text, url)
    with_http_rescue do
      uri = URI.parse(MY_TWEET[:api_url])
      req = Net::HTTP::Post.new(uri)
      req["Content-Type"] = "application/json"
      req["Authorization"] = "Bearer #{access_token}"
      req.body = { text: text, url: url }.to_json
      res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
      res.is_a?(Net::HTTPCreated)
    end
  end

  private

  def with_http_rescue
    yield
  rescue StandardError => e
    # ネットワークエラーや 500 系などの通信エラーを MyTweetApiClient::Error に集約して raise する。
    # （本来はエラー毎にエラークラス定義して処理してあげたい）
    # 受け側は application_controller の rescue_from で一元的にハンドリングする。
    raise Error, e.message
  end
end
