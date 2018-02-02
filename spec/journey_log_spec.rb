require 'journey_log'

describe JourneyLog do

  subject(:journey_log) { described_class.new(journey_class)    }
  let(:journey_class)   { double("Journey class", new: journey) }
  let(:journey)         { double("a journey", finish: station)  }
  let(:station)         { double("a station")                   }

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

  describe '#finish' do

    before(:each) do
      journey_log.start(station)
    end

    it 'sends finish to current journey' do
      expect(journey_log.current_journey).to receive(:finish).with(station)
      journey_log.finish(station)
    end

    it 'adds @current_journey to @journeys array' do
      journey_log.finish(station)
      expect(journey_log.journeys).to include journey
    end
  end

end
