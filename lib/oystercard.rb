require_relative 'station'
require_relative 'journey'

class Oystercard

  FINE = 6
  BALANCE_LIMIT = 90
  BALANCE_MIN = 1
  MIN_CHARGE = 3

  attr_reader :balance, :entry_station, :exit_station, :journey_history

  def initialize(balance = 0, in_journey = nil)
    @balance = balance
    @in_journey = in_journey
    @journey_history = []

  end

  def in_journey?
    !!@current_journey
  end

  def touch_in(station, journey_class)
    pre_touch_in_checks
    fine = journey_class.new.fare if @current_journey
    deduct(fine) if fine
    @current_journey = journey_class.new(station)
    @entry_station = station
  end

  def touch_out(station)
    @exit_station = station
    @current_journey.finish(station)
    deduct(MIN_CHARGE)
    store_journey_history
    @in_journey = false
    @entry_station, @exit_station = nil, nil
  end

  def top_up(amount)
    pre_top_up_checks(amount)
    @balance += amount
  end

  def store_journey_history
    @journey_history << @in_journey
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def pre_top_up_checks(amount)
    fail "Error - maximum balance is #{BALANCE_LIMIT} pounds" if (@balance + amount > BALANCE_LIMIT)
  end

  def pre_touch_in_checks
    # deduct(FINE) if in_journey?
    fail "Insufficient funds - minimum balance is #{BALANCE_MIN}" if @balance < BALANCE_MIN
  end

end
