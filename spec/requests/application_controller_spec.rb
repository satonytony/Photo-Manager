require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  let(:user) { create(:user) }

  describe "#require_login" do
    context "未ログイン状態でアクセスしたとき" do
      it "ログイン画面にリダイレクトする" do
        get photos_path
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログイン済みのとき" do
      before { post login_path, params: { email: user.email, password: "password" } }

      it "リダイレクトしない" do
        get photos_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "#current_user" do
    context "ログイン後にセッションが有効なとき" do
      before { post login_path, params: { email: user.email, password: "password" } }

      it "リクエスト間でユーザーが維持される" do
        get photos_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン後にユーザーが削除されたとき" do
      before do
        post login_path, params: { email: user.email, password: "password" }
        user.destroy
      end

      it "ログイン画面にリダイレクトする" do
        get photos_path
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
