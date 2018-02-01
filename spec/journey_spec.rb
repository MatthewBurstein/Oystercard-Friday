require 'journey'

describe Journey do

  let(:station) { double("a station") }
  subject(:journey_with_entry) { described_class.new(station) }

  describe "#fare" do

    context "when journey has entry and exit stations" do
      before :each do
        journey_with_entry.finish(station)
      end

      it "charges the minimum charge" do
        expect(journey_with_entry.fare).to eq Journey::MIN_CHARGE
      end
    end

    context "When no exit station" do
      it "returns the fine" do
        expect(journey_with_entry.fare).to eq Journey::FINE
      end
    end

    context "when no entry station" do
      subject(:journey_without_entry) { described_class.new }
      before :each do
        journey_without_entry.finish(station)
      end

      it "charges the fine" do
        expect(journey_without_entry.fare).to eq Journey::FINE
      end
    end
  end

  describe "#finish" do
    it "sets @exit_station to the passed argument" do
      expect(journey_with_entry.finish(station)).to eq station 
    end
  end

end
