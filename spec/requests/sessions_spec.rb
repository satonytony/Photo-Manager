require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let!(:user) { create(:user, email: "test@example.com", password: "password") }

  describe "GET /login" do
    it "returns 200" do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /login" do
    context "with valid credentials" do
      it "redirects to photos path" do
        post login_path, params: { email: "test@example.com", password: "password" }
        expect(response).to redirect_to(photos_path)
      end

      it "is case-insensitive for email" do
        post login_path, params: { email: "TEST@EXAMPLE.COM", password: "password" }
        expect(response).to redirect_to(photos_path)
      end
    end

    context "with blank email" do
      it "re-renders login with error" do
        post login_path, params: { email: "", password: "password" }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("メールアドレスを入力してください")
      end
    end

    context "with blank password" do
      it "re-renders login with error" do
        post login_path, params: { email: "test@example.com", password: "" }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("パスワードを入力してください")
      end
    end

    context "with both blank" do
      it "shows both errors" do
        post login_path, params: { email: "", password: "" }
        expect(response.body).to include("メールアドレスを入力してください")
        expect(response.body).to include("パスワードを入力してください")
      end
    end

    context "with wrong password" do
      it "re-renders login with error" do
        post login_path, params: { email: "test@example.com", password: "wrong" }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("メールアドレスとパスワードが一致するユーザーが存在しません")
      end
    end

    context "with wrong password" do
      it "preserves email input" do
        post login_path, params: { email: "test@example.com", password: "wrong" }
        expect(response.body).to include("test@example.com")
      end
    end
  end

  describe "DELETE /logout" do
    it "redirects to login" do
      post login_path, params: { email: "test@example.com", password: "password" }
      delete logout_path
      expect(response).to redirect_to(login_path)
    end
  end

  describe "GET /photos (require_login)" do
    it "redirects to login when not logged in" do
      get photos_path
      expect(response).to redirect_to(login_path)
    end

    it "renders 200 when logged in" do
      post login_path, params: { email: "test@example.com", password: "password" }
      get photos_path
      expect(response).to have_http_status(:ok)
    end
  end
end
