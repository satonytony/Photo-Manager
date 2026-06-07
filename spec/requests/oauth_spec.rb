require "rails_helper"

RSpec.describe OauthController, type: :request do
  it_behaves_like "ログイン必須"

  describe "GET /oauth/authorize" do
    let(:user) { create(:user) }

    before { post "/login", params: { email: user.email, password: "password" } }

    it "外部OAuth認可URLへリダイレクトする" do
      get oauth_authorize_path
      expect(response).to redirect_to(/oauth\/authorize/)
      expect(response.location).to include("response_type=code")
      expect(response.location).to include("redirect_uri=")
      expect(response.location).to include("scope=write_tweet")
    end
  end

  describe "GET /oauth/callback" do
    let(:user) { create(:user) }

    before { post "/login", params: { email: user.email, password: "password" } }

    it "エラーにならない" do
      get oauth_callback_path
      expect(response).not_to have_http_status(:server_error)
    end
  end
end
