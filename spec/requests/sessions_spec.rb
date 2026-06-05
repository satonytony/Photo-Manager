require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let!(:user) { create(:user, email: "test@example.com", password: "password") }

  describe "GET /login" do
    it "200を返す" do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /login" do
    context "正しい認証情報の場合" do
      it "写真一覧にリダイレクトする" do
        post login_path, params: { email: "test@example.com", password: "password" }
        expect(response).to redirect_to(photos_path)
      end

      it "メールアドレスの大文字小文字を区別しない" do
        post login_path, params: { email: "TEST@EXAMPLE.COM", password: "password" }
        expect(response).to redirect_to(photos_path)
      end
    end

    context "メールアドレスが空の場合" do
      it "ログイン画面を再描画しエラーメッセージを表示する" do
        post login_path, params: { email: "", password: "password" }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("メールアドレスを入力してください")
      end
    end

    context "パスワードが空の場合" do
      it "ログイン画面を再描画しエラーメッセージを表示する" do
        post login_path, params: { email: "test@example.com", password: "" }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("パスワードを入力してください")
      end
    end

    context "メールアドレスとパスワードが両方空の場合" do
      it "両方のエラーメッセージを表示する" do
        post login_path, params: { email: "", password: "" }
        expect(response.body).to include("メールアドレスを入力してください")
        expect(response.body).to include("パスワードを入力してください")
      end
    end

    context "パスワードが間違っている場合" do
      it "ログイン画面を再描画しエラーメッセージを表示する" do
        post login_path, params: { email: "test@example.com", password: "wrong" }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("メールアドレスとパスワードが一致するユーザーが存在しません")
      end

      it "入力したメールアドレスを保持する" do
        post login_path, params: { email: "test@example.com", password: "wrong" }
        expect(response.body).to include("test@example.com")
      end
    end
  end

  describe "GET /photos（ログイン必須）" do
    it "未ログイン時はログイン画面にリダイレクトする" do
      get photos_path
      expect(response).to redirect_to(login_path)
    end

    it "ログイン済みの場合は200を返す" do
      post login_path, params: { email: "test@example.com", password: "password" }
      get photos_path
      expect(response).to have_http_status(:ok)
    end
  end
end
