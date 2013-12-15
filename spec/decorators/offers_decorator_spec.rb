require "spec_helper"

describe OffersDecorator do

  describe '#all' do

    context 'there are offers' do
      subject { described_class.new OpenStruct.new offers: [:some_offer] }

      it { expect(subject.all).to include :some_offer }
    end

    context 'there is no offer' do
      subject { described_class.new OpenStruct.new offers: nil }

      it { expect(subject.all).to be_empty }
    end

  end

  describe '#fine?' do

    context 'code is fine' do
      let(:fine)        { described_class.new OpenStruct.new code: 'OK' }
      let(:rather_fine) { described_class.new OpenStruct.new code: 'NO_CONTENT' }

      it { expect(fine.fine?).to be true }
      it { expect(rather_fine.fine?).to be true }
    end

    context 'code is wrong' do
      subject { described_class.new OpenStruct.new code: 'WRONG' }

      it { expect(subject.fine?).to be false }
    end

  end

  describe '#no?' do
    let(:with_content)    { described_class.new OpenStruct.new code: 'OK' }
    let(:without_content) { described_class.new OpenStruct.new code: 'NO_CONTENT' }

    it 'checks NO_CONTENT status' do
      expect(with_content.no?).to be false
      expect(without_content.no?).to be true
    end
  end

end
