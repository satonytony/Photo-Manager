RSpec.shared_examples "ログイン必須" do
  it "before_action :require_login が設定されている" do
    callbacks = described_class._process_action_callbacks
    expect(callbacks.any? { |c| c.kind == :before && c.filter == :require_login }).to be true
  end
end
