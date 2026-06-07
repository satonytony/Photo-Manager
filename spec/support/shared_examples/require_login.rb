RSpec.shared_context "ログイン必須の担保" do
  # ログイン不要なコントローラ（意図的に skip_before_action :require_login しているもの）はここで明示的に除外する。
  # それ以外で ApplicationController を継承するコントローラには require_login が有効であることを必須とする。
  login_not_required = [ SessionsController ]

  if described_class.is_a?(Class) &&
     described_class < ApplicationController &&
     !login_not_required.include?(described_class)
    it "before_action :require_login が有効でログイン必須が担保されている" do
      # skip_before_action されている場合はコールバックチェーンから除外されるため、
      # 継承の有無ではなく require_login が実際に before_action として効いているかを検証する。
      before_filters = described_class._process_action_callbacks
                                      .select { |c| c.kind == :before }
                                      .map(&:filter)
      expect(before_filters).to include(:require_login)
    end
  end
end
