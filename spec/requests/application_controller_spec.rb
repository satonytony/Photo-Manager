require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  describe "#require_login" do
    context "未ログイン状態でアクセスしたとき" do
      it "ログイン画面にリダイレクトする" do
        get photos_path
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログイン済みのとき" do
      login

      it "リダイレクトしない" do
        get photos_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "#current_user" do
    context "ログイン後にセッションが有効なとき" do
      login

      it "リクエスト間でユーザーが維持される" do
        get photos_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン後にユーザーが削除されたとき" do
      login
      before { user.destroy }

      it "ログイン画面にリダイレクトする" do
        get photos_path
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
