require "rails_helper"

RSpec.describe MyTweetApiClient do
  let(:dummy_class) { Class.new { include MyTweetApiClient } }
  let(:instance) { dummy_class.new }

  describe "#fetch_access_token" do
    context "2xx レスポンスの場合" do
      before do
        fake_res = double("success_response")
        allow(fake_res).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        allow(fake_res).to receive(:body).and_return({ access_token: "token_xyz" }.to_json)
        allow(Net::HTTP).to receive(:post_form).and_return(fake_res)
      end

      it "アクセストークンを返す" do
        expect(instance.fetch_access_token("code_abc")).to eq("token_xyz")
      end
    end

    context "4xx/5xx レスポンスの場合" do
      before do
        fake_res = double("error_response")
        allow(fake_res).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
        allow(Net::HTTP).to receive(:post_form).and_return(fake_res)
      end

      it "nil を返す" do
        expect(instance.fetch_access_token("code_abc")).to be_nil
      end
    end

    context "ネットワークエラーの場合" do
      before { allow(Net::HTTP).to receive(:post_form).and_raise(SocketError) }

      it "nil を返す" do
        expect(instance.fetch_access_token("code_abc")).to be_nil
      end
    end
  end
end
