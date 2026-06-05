require "rails_helper"

RSpec.describe User, type: :model do
  describe "email normalization" do
    it "downcases email on save" do
      user = create(:user, email: "TEST@EXAMPLE.COM")
      expect(user.reload.email).to eq "test@example.com"
    end

    it "strips whitespace from email" do
      user = create(:user, email: "  user@example.com  ")
      expect(user.reload.email).to eq "user@example.com"
    end
  end

  describe "authentication" do
    it "authenticates with correct password" do
      user = create(:user, password: "secret")
      expect(user.authenticate("secret")).to eq user
    end

    it "rejects wrong password" do
      user = create(:user, password: "secret")
      expect(user.authenticate("wrong")).to be_falsey
    end
  end

  describe "validations" do
    it "is invalid without email" do
      user = build(:user, email: "")
      expect(user).not_to be_valid
    end

    it "is invalid without password on create" do
      user = build(:user, password: "")
      expect(user).not_to be_valid
    end
  end
end
