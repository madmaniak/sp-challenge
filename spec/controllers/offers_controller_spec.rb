require "spec_helper"

describe OffersController do

  describe "POST index" do

    let(:options) { { uid: '1', pub0: '1', page: '1' }.stringify_keys }
    let(:api_response) {
      { get: { message: 'OK', code: 'OK', offers: [] } }
    }

    before do
      allow(Offers).to receive(:new).and_return Hashie::Mash.new(r: api_response).r
    end

    it "asks for offers" do
      expect(Offers).to receive(:new).with(options)
      post :index, options
    end

    it "renders the index template" do
      post :index
      expect(response).to render_template("index")
    end
  end

end

