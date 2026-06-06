require 'rails_helper'

RSpec.describe PhotosController, type: :request do
  it_behaves_like "ログイン必須"

  describe "GET /photos" do
    context "ログイン済みのとき" do
      let(:user) { create(:user) }

      before do
        post "/login", params: { email: user.email, password: "password" }
      end

      it "200を返す" do
        get photos_path
        expect(response).to have_http_status(:ok)
      end

      it "自分の写真のタイトルが表示される" do
        photo = create(:photo, user: user, title: "マイ写真")
        get photos_path
        expect(response.body).to include("マイ写真")
      end

      it "他ユーザーの写真は表示されない" do
        other_user = create(:user)
        create(:photo, user: other_user, title: "他人の写真")
        get photos_path
        expect(response.body).not_to include("他人の写真")
      end

      it "写真が最新順（created_at DESC）で表示される" do
        older = create(:photo, user: user, title: "古い写真", created_at: 2.days.ago)
        newer = create(:photo, user: user, title: "新しい写真", created_at: 1.day.ago)
        get photos_path
        expect(response.body.index("新しい写真")).to be < response.body.index("古い写真")
      end

      it "写真が0件のとき200を返す" do
        get photos_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
