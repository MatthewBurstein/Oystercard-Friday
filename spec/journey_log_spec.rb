require 'journey_log'

describe JourneyLog do

  subject(:journey_log) { described_class.new(journey_class) }
  let(:journey_class)   { double("Journey", new: journey) }
  let(:journey)         { double("a journey class")}
  let(:station)         { double("a station") }

  it { is_expected.to respond_to(:start).with(1).argument }

  describe 'attributes' do

    it 'initializes with an empty array @journeys'do
      expect(journey_log.journeys).to eq []
    end

  end

  describe "#start" do
    it "returns a new journey object" do
      expect(journey_log.start(station)).to eq journey
    end
  end

end
