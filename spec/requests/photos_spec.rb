require 'rails_helper'

RSpec.describe PhotosController, type: :request do
  login

  describe "GET /photos" do
    it "200を返す" do
      get photos_path
      expect(response).to have_http_status(:ok)
    end

    it "自分の写真のタイトルが表示される" do
      create(:photo, :with_image, user: user, title: "マイ写真")
      get photos_path
      expect(response.body).to include("マイ写真")
    end

    it "他ユーザーの写真は表示されない" do
      other_user = create(:user)
      create(:photo, :with_image, user: other_user, title: "他人の写真")
      get photos_path
      expect(response.body).not_to include("他人の写真")
    end

    it "写真が最新順（created_at DESC）で表示される" do
      create(:photo, :with_image, user: user, title: "古い写真", created_at: 2.days.ago)
      create(:photo, :with_image, user: user, title: "新しい写真", created_at: 1.day.ago)
      get photos_path
      expect(response.body.index("新しい写真")).to be < response.body.index("古い写真")
    end

    it "写真が0件のとき200を返す" do
      get photos_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /photos/new" do
    it "200を返す" do
      get new_photo_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /photos" do
    let(:image) { fixture_file_upload(Rails.root.join("spec/fixtures/files/test_image.jpg"), "image/jpeg") }

    context "タイトルと画像が正しいとき" do
      it "写真を作成して一覧にリダイレクトする" do
        expect {
          post photos_path, params: { photo: { title: "テスト写真", image: image } }
        }.to change(Photo, :count).by(1)
        expect(response).to redirect_to(photos_path)
      end

      it "ログインユーザーに紐づく" do
        post photos_path, params: { photo: { title: "テスト写真", image: image } }
        expect(Photo.last.user).to eq user
      end
    end

    context "タイトルが空のとき" do
      it "422を返してアップロード画面を再表示する" do
        post photos_path, params: { photo: { title: "", image: image } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "タイトルが31文字のとき" do
      it "422を返す" do
        post photos_path, params: { photo: { title: "a" * 31, image: image } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "画像が未添付のとき" do
      it "422を返す" do
        post photos_path, params: { photo: { title: "タイトルあり" } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "POST /photos/:id/tweet" do
    let(:photo) { create(:photo, :with_image, user: user) }

    context "ツイートが成功するとき" do
      before { allow_any_instance_of(PhotosController).to receive(:post_tweet).and_return(true) }

      it "写真一覧にリダイレクトする" do
        post tweet_photo_path(photo)
        expect(response).to redirect_to(photos_path)
      end
    end

    context "ツイートAPIが失敗する（500系）とき" do
      before { allow_any_instance_of(PhotosController).to receive(:post_tweet).and_return(false) }

      it "写真一覧にリダイレクトする" do
        post tweet_photo_path(photo)
        expect(response).to redirect_to(photos_path)
      end
    end

    context "ネットワークエラーでツイートが失敗するとき" do
      before { allow_any_instance_of(PhotosController).to receive(:post_tweet).and_return(nil) }

      it "写真一覧にリダイレクトする" do
        post tweet_photo_path(photo)
        expect(response).to redirect_to(photos_path)
      end
    end
  end
end
