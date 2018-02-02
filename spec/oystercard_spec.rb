require 'oystercard'

describe Oystercard do

  subject(:card) { described_class.new }

  let(:station) { double "a station" }
  let(:station2) { double "a second station" }

  let(:card_touched_in) do
    card.top_up(10)
    card.touch_in(station)
    card
  end

  let(:card_touched_out) do
    card_touched_in.touch_out(station2)
    card_touched_in
  end

  describe 'balance' do
    it 'when initialized has a balance of 0' do
      expect(card.balance).to be_zero
    end

    it 'raises error when Oystercard balance is greater than 90 pounds' do
      balance_limit = Oystercard::BALANCE_LIMIT
      card.top_up(balance_limit)
      message = "Error - maximum balance is #{balance_limit} pounds"
      expect { card.top_up(1) }.to raise_error(message)
    end
  end

  describe '#touch in' do

    it 'changes status to true' do
      expect(card_touched_in).to be_in_journey
    end

    it 'correctly stores the entry station' do
      expect(card_touched_in.current_journey).to be_instance_of Journey
    end

    context "when balance is below one pound" do
      it 'prevents touching in' do
        minimum_balance = Oystercard::BALANCE_MIN
        message = "Insufficient funds - minimum balance is #{minimum_balance}"
        expect { card.touch_in(station) }.to raise_error message
      end
    end

    context 'when in journey' do
      before :each do
        card.top_up(10)
        card.touch_in(station)
      end

      it 'fines the card' do
        expect {card.touch_in(station)}.to change{card.balance}.by (-Journey::FINE)
      end
    end
  end

  describe '#touch out' do
    it 'changes status to false' do
      card_touched_out
      expect(card_touched_in).not_to be_in_journey
    end

    it 'deducts the minimum fare' do
      card_touched_in
      expect { card_touched_in.touch_out(station) }.to change { card.balance }.by(-Journey::MIN_CHARGE)
    end
  end

  describe '#top_up' do
    it 'adjusts balance by top up amount' do
      expect { card.top_up(1) }.to change { card.balance }.by(1)
    end
  end

  describe '#journey_history' do
    it 'starts off as being empty' do
      expect(card.journey_history).to eq []
    end

    it 'stores the last journey' do
      expect(card_touched_out.journey_history.last).to be_an_instance_of Journey
    end
  end
end
