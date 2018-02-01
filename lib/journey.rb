class Journey

  MIN_CHARGE = 3
  FINE = 6

  def initialize(entry_station = nil)
  @entry_station = entry_station
  end

  def fare
    complete? ? FINE : MIN_CHARGE
  end

  def finish(station)
    @exit_station = station
  end

  private

  def complete?
    !(@entry_station && @exit_station)
  end


end
