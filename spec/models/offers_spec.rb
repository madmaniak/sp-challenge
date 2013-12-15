require "spec_helper"

describe Offers do

  subject { described_class.new }

  it 'has offer_types option' do
    expect(subject.options).to include 'offer_types'
  end

end
