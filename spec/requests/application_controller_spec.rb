require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  describe "#require_login" do
    context "未ログイン状態でアクセスしたとき" do
      it "ログイン画面にリダイレクトする" do
        get photos_path
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
