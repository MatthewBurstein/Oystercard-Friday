require_relative 'station'
require_relative 'journey'

class Oystercard

  BALANCE_LIMIT = 90
  BALANCE_MIN = 1

  attr_reader :balance, :journey_history, :current_journey

  def initialize(balance = 0, journey_class = Journey)
    @balance = balance
    @journey_history = []
    @journey_class = Journey
  end

  def in_journey?
    !!@current_journey
  end

  def touch_in(station)
    pre_touch_in_checks(@journey_class)
    @current_journey = @journey_class.new(station)
  end

  def touch_out(station)
    @current_journey.finish(station)
    deduct(@current_journey.fare)
    store_journey_history
  end

  def top_up(amount)
    pre_top_up_checks(amount)
    @balance += amount
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def pre_top_up_checks(amount)
    fail "Error - maximum balance is #{BALANCE_LIMIT} pounds" if (@balance + amount > BALANCE_LIMIT)
  end

  def pre_touch_in_checks(journey_class)
    deduct(journey_class.new.fare) if @current_journey
    fail "Insufficient funds - minimum balance is #{BALANCE_MIN}" if @balance < BALANCE_MIN
  end

  def store_journey_history
    @journey_history << @current_journey
    @current_journey = nil
  end

end
