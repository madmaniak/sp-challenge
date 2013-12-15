require 'httparty'

module SP
  class Action

    include HTTParty
    base_uri "#{SPConfig['uri']}/v#{SPConfig['version']}"

    cattr_reader :defaults

    @@api_key = SPConfig['api_key']
    @@defaults = ['appid', 'device_id', 'ip', 'locale']

    def self.options hash = {}
      define_method(:sec_options) { hash.stringify_keys }
    end

    def initialize hash = {}
      @params = hash.stringify_keys
      define_get
    end

    def options
      @options ||= merge_options
    end

    private

    def merge_options
      sec = try(:sec_options) || {}

      SPConfig.select{ |c| @@defaults.include? c }
      .merge(sec)
      .merge(@params)
    end

    def define_get
      define_singleton_method :get do
        action = self.class.to_s.underscore

        Rails.cache.fetch "#{action}#{@params.values.join}", expires_in: 1.minute do
          response = self.class.get "/#{action}.json?" + prepared_options
          valid_response = validate! response
          make_object valid_response
        end

      end
    end

    def prepared_options
      timestamp = Time.now.to_i
      query = options.merge( timestamp: timestamp ).to_query + '&'
      hashkey = generate_hashkey(query)

      "#{query}#{ {hashkey: hashkey}.to_query }"
    end

    def validate! response
      signature = response.headers['x-sponsorpay-response-signature']

      if signature == generate_hashkey(response.body)
        response.parsed_response
      else
        { code: 'UNAUTHORIZED', message: 'Unauthorized response.', offers: [] }
      end
    end

    def generate_hashkey(query)
      Digest::SHA1.hexdigest "#{query}#{@@api_key}"
    end

    def make_object(hash)
      Hashie::Mash.new(r: hash).r
    end

  end
end
