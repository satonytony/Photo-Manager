RSpec.shared_examples "ログイン必須" do
  it "未ログイン状態でアクセスするとログイン画面にリダイレクトする" do
    get target_path
    expect(response).to redirect_to(login_path)
  end
end
