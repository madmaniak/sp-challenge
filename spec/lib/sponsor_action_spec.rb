require "spec_helper"

describe SP::Action do

  context 'Pure inherited class instance' do
    subject { class SomeAction < described_class; end; SomeAction.new }

    describe "base_uri" do

      let(:base_uri) { subject.class.default_options[:base_uri] }

      it "get's uri from config" do
        expect(base_uri).to match /#{SPConfig['uri']}/
      end

      it "get's version from config" do
        expect(base_uri).to match /v#{SPConfig['version']}/
      end

    end

    describe '#options' do

      let(:options) { subject.send :options }

      it "'s a Hash" do
        expect(options).to be_a Hash
      end


      let(:default_options) { subject.class.defaults }

      it "has default options" do
        expect(options.keys).to include *default_options
      end

      it "gets default options from config" do
        default_options.each do |option|
          expect(options[option]).to eq(SPConfig[option])
        end
      end

    end

    describe '#get' do

      # test depends on config/config.yml

      let(:response) { OpenStruct.new \
        headers: { 'x-sponsorpay-response-signature' => 0 },
        body: '"such_a_nice_body": "nice body"',
        parsed_response: { such_a_nice_body: 'nice body' }
      }

      before do
        allow(Time).to receive(:now).and_return 0
        allow(subject.class).to receive(:get).and_return response
      end

      it "'s called with proper action and options" do
        expect(subject.class).to receive(:get).with "/some_action.json?appid=900&device_id=some_id&ip=192.168.1.2&locale=pl&timestamp=0&hashkey=41b7f1ccd129aa6038cc9fb3c8d4fe8f55bb54bc"
        subject.get
      end

      context 'invalid response signature' do

        it "returns UNAUTHORIZED object" do
          expect(subject.get.code).to eq 'UNAUTHORIZED'
        end

      end

      context 'valid signature' do

        before do
          response.headers = {'x-sponsorpay-response-signature' => "9f3c84674a5b9b30c59105a4cdc0a589456b7fe1" }
        end

        it "returns response data object" do
          expect(subject.get.such_a_nice_body).to eq 'nice body'
        end

      end

    end

  end

  context "Inherited class with defined options" do

    subject {
      class AnotherAction < described_class
        options locale: :en, another_option: :another_option_value
      end

      AnotherAction.new
    }

    describe '#options' do

      let(:options) { subject.send :options }
      let(:default_options) { subject.class.defaults }

      it "has default and additional options" do
        expect(options.keys).to include *default_options
        expect(options.keys).to include 'locale', 'another_option'
      end

      it "overrides options from config and set additional ones" do
        expect(options['locale']).to eq :en
        expect(options['another_option']).to eq :another_option_value
      end

    end

  end

  context "Inherited class with defined options and params on initialization" do

    subject {
      class OneMoreAction < described_class
        options locale: :en, another_option: :another_option_value
      end

      OneMoreAction.new locale: :de, one_more_option: :one_more_value
    }

    describe '#options' do

      let(:options) { subject.send :options }
      let(:default_options) { subject.class.defaults }

      it "has default, additional and initialization options" do
        expect(options.keys).to include *default_options
        expect(options.keys).to include 'locale', 'another_option'
        expect(options.keys).to include 'one_more_option'
      end

      it "overrides options with initialization ones" do
        expect(options['locale']).to eq :de
        expect(options['one_more_option']).to eq :one_more_value
      end

    end

  end

end
