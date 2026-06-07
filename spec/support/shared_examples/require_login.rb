RSpec.shared_context "ログイン必須" do
  if described_class.is_a?(Class) && described_class < ApplicationController && described_class != SessionsController
    it "ApplicationController を継承している" do
      expect(described_class < ApplicationController).to be(true)
    end
  end
end
