RSpec.shared_context "ApplicationController継承確認" do
  if described_class.is_a?(Class) && described_class < ApplicationController && described_class != SessionsController
    it "ApplicationController を継承している" do
      # ApplicationController を継承していれば before_action :require_login が自動適用され、ログイン必須が担保される
      expect(described_class < ApplicationController).to be(true)
    end
  end
end
