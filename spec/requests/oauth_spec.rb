require "rails_helper"

RSpec.describe OauthController, type: :request do
  login

  describe "GET /oauth/authorize" do
    it "外部OAuth認可URLへリダイレクトする" do
      get oauth_authorize_path
      expect(response).to redirect_to(/oauth\/authorize/)
      expect(response.location).to include("response_type=code")
      expect(response.location).to include("redirect_uri=")
      expect(response.location).to include("scope=write_tweet")
    end
  end

  describe "GET /oauth/callback" do
    context "認可コードがある場合" do
      let(:access_token) { "test_access_token_xyz" }

      context "トークン取得に成功した場合" do
        before do
          fake_res = double("success_response")
          allow(fake_res).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
          allow(fake_res).to receive(:body).and_return({ access_token: access_token }.to_json)
          allow(Net::HTTP).to receive(:post_form).and_return(fake_res)
        end

        it "アクセストークンをセッションに格納する" do
          get oauth_callback_path, params: { code: "auth_code_abc" }
          expect(session[:access_token]).to eq(access_token)
        end

        it "写真一覧へリダイレクトする" do
          get oauth_callback_path, params: { code: "auth_code_abc" }
          expect(response).to redirect_to(photos_path)
        end
      end

      context "トークン取得にエラーがあった場合" do
        before { allow(Net::HTTP).to receive(:post_form).and_raise(SocketError) }

        it "MyTweetApiClient::Error が raise される" do
          expect { get oauth_callback_path, params: { code: "auth_code_abc" } }.to raise_error(MyTweetApiClient::Error)
        end
      end
    end

    context "認可コードがない場合" do
      it "エラーにならず写真一覧へリダイレクトする" do
        get oauth_callback_path
        expect(response).to redirect_to(photos_path)
      end
    end
  end
end
