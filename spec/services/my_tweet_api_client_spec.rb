require "rails_helper"

RSpec.describe MyTweetApiClient do
  let(:instance) { MyTweetApiClient.new }

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
        allow(fake_res).to receive(:code).and_return("500")
        allow(Net::HTTP).to receive(:post_form).and_return(fake_res)
      end

      it "MyTweetApiClient::Error を raise する" do
        expect { instance.fetch_access_token("code_abc") }.to raise_error(MyTweetApiClient::Error)
      end
    end

    context "ネットワークエラーの場合" do
      before { allow(Net::HTTP).to receive(:post_form).and_raise(SocketError) }

      it "MyTweetApiClient::Error を raise する" do
        expect { instance.fetch_access_token("code_abc") }.to raise_error(MyTweetApiClient::Error)
      end
    end
  end

  describe "#post_tweet" do
    context "201 レスポンスの場合" do
      before do
        fake_res = double("created_response")
        allow(fake_res).to receive(:is_a?).with(Net::HTTPCreated).and_return(true)
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(fake_res)
      end

      it "エラーを raise しない" do
        expect { instance.post_tweet("token_xyz", "タイトル", "http://localhost:3000/photos/1.jpg") }.not_to raise_error
      end
    end

    context "201 以外のレスポンスの場合" do
      before do
        fake_res = double("error_response")
        allow(fake_res).to receive(:is_a?).with(Net::HTTPCreated).and_return(false)
        allow(fake_res).to receive(:code).and_return("500")
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(fake_res)
      end

      it "MyTweetApiClient::Error を raise する" do
        expect { instance.post_tweet("token_xyz", "タイトル", "http://localhost:3000/photos/1.jpg") }.to raise_error(MyTweetApiClient::Error)
      end
    end

    context "ネットワークエラーの場合" do
      before { allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(SocketError) }

      it "MyTweetApiClient::Error を raise する" do
        expect { instance.post_tweet("token_xyz", "タイトル", "http://localhost:3000/photos/1.jpg") }.to raise_error(MyTweetApiClient::Error)
      end
    end
  end
end
