class JourneyLog

  attr_reader :journeys

  def initialize(journey_class = Journey)
    @journeys = []
    @journey_class = journey_class
  end

  def start(station)
    @journey_class.new(station)
  end


end
