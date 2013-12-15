require 'httparty'

module SP

  class Action
    include HTTParty
    base_uri 'api.sponsorpay.com/feed/v1'

    def initialize uid, pub0, page
      @params = { uid: uid, pub0: pub0, page: page }
    end

    def options
      @options ||= {
        appid: 157,
        device_id: '2b6f0cc904d137be2e1730235f5664094b831186',
        locale: :de,
        ip: '109.235.143.113',
        offer_types: 112,
      }
    end

    def offers
      self.class.get '/offers.json?' + prepared_options
    end

    private

    def prepared_options
      timestamp = Time.now.to_i
      query = options.merge(@params).merge( timestamp: timestamp ).to_query

      hashkey = Digest::SHA1.hexdigest \
        query + '&b07a12df7d52e6c118e5d47d3f9e60135b109a1f'

      "#{query}&#{ {hashkey: hashkey}.to_query }"
    end
  end

end
