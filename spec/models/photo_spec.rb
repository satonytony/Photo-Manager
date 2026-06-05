require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe 'バリデーション' do
    context 'titleが空のとき' do
      it '無効である' do
        photo = build(:photo, title: '')
        expect(photo).not_to be_valid
        expect(photo.errors[:title]).to be_present
      end
    end

    context 'titleが30文字のとき' do
      it '有効である' do
        photo = build(:photo, title: 'a' * 30)
        expect(photo).to be_valid
      end
    end

    context 'titleが31文字のとき' do
      it '無効である' do
        photo = build(:photo, title: 'a' * 31)
        expect(photo).not_to be_valid
        expect(photo.errors[:title]).to be_present
      end
    end

    context '全属性が正しいとき' do
      it '有効である' do
        photo = build(:photo)
        expect(photo).to be_valid
      end
    end
  end
end
