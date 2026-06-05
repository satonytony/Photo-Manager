require "rails_helper"

RSpec.describe User, type: :model do
  describe "メールアドレスの正規化" do
    it "保存時にメールアドレスを小文字に変換する" do
      user = create(:user, email: "TEST@EXAMPLE.COM")
      expect(user.reload.email).to eq "test@example.com"
    end

    it "保存時にメールアドレスの前後の空白を除去する" do
      user = create(:user, email: "  user@example.com  ")
      expect(user.reload.email).to eq "user@example.com"
    end
  end

  describe "認証" do
    it "正しいパスワードで認証できる" do
      user = create(:user, password: "secret")
      expect(user.authenticate("secret")).to eq user
    end

    it "誤ったパスワードでは認証できない" do
      user = create(:user, password: "secret")
      expect(user.authenticate("wrong")).to be_falsey
    end
  end

  describe "バリデーション" do
    it "メールアドレスがない場合は無効である" do
      user = build(:user, email: "")
      expect(user).not_to be_valid
    end

    it "新規作成時にパスワードがない場合は無効である" do
      user = build(:user, password: "")
      expect(user).not_to be_valid
    end
  end
end
